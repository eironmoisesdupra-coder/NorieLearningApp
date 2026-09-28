import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const jsonHeaders = { ...corsHeaders, "Content-Type": "application/json" };
const bucket = "study-sources";

function reply(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: jsonHeaders });
}

function extractOutputText(data: any): string {
  if (typeof data?.output_text === "string") return data.output_text;
  for (const item of data?.output ?? []) {
    for (const content of item?.content ?? []) {
      if (content?.type === "output_text" && typeof content?.text === "string") {
        return content.text;
      }
    }
  }
  return "";
}

function extractJsonObject(text: string): string {
  const first = text.indexOf("{");
  const last = text.lastIndexOf("}");
  if (first < 0 || last <= first) throw new Error("No JSON object returned");
  return text.slice(first, last + 1);
}

function bytesToBase64(bytes: Uint8Array): string {
  let binary = "";
  const chunk = 0x8000;
  for (let i = 0; i < bytes.length; i += chunk) {
    binary += String.fromCharCode(...bytes.subarray(i, i + chunk));
  }
  return btoa(binary);
}

function sourceMime(sourceType: string, filename: string, supplied: string): string {
  if (supplied) return supplied;
  const lower = filename.toLowerCase();
  if (lower.endsWith(".pdf")) return "application/pdf";
  if (lower.endsWith(".docx")) return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
  if (lower.endsWith(".doc")) return "application/msword";
  if (lower.endsWith(".pptx")) return "application/vnd.openxmlformats-officedocument.presentationml.presentation";
  if (lower.endsWith(".ppt")) return "application/vnd.ms-powerpoint";
  if (lower.endsWith(".md")) return "text/markdown";
  if (lower.endsWith(".txt")) return "text/plain";
  if (lower.endsWith(".png")) return "image/png";
  if (lower.endsWith(".webp")) return "image/webp";
  if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) return "image/jpeg";
  return sourceType === "image" ? "image/jpeg" : "application/octet-stream";
}

async function sha256Hex(value: string): Promise<string> {
  const bytes = new TextEncoder().encode(value);
  const digest = await crypto.subtle.digest("SHA-256", bytes);
  return Array.from(new Uint8Array(digest))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

type AiProviderResult = {
  provider: string;
  model: string;
  data: any;
  inputUnits: number | null;
  outputUnits: number | null;
};

async function callAiProvider({
  systemPrompt,
  userContent,
}: {
  systemPrompt: string;
  userContent: any[];
}): Promise<AiProviderResult> {
  const provider = (Deno.env.get("NORIE_AI_PROVIDER") || "openai").trim().toLowerCase();

  if (provider !== "openai") {
    throw new Error("provider_not_configured:" + provider);
  }

  const apiKey = Deno.env.get("OPENAI_API_KEY");
  if (!apiKey) throw new Error("ai_not_configured");

  const model = Deno.env.get("OPENAI_MODEL") || "gpt-5.6-luna";
  const response = await fetch("https://api.openai.com/v1/responses", {
    method: "POST",
    headers: {
      "Authorization": "Bearer " + apiKey,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model,
      input: [
        { role: "system", content: [{ type: "input_text", text: systemPrompt }] },
        { role: "user", content: userContent },
      ],
    }),
  });

  if (!response.ok) {
    const errorText = await response.text();
    console.error("AI provider error", provider, response.status, errorText.slice(0, 1000));

    let safeMessage = "The AI provider rejected the generation request.";
    let safeCode = "ai_request_failed";
    try {
      const parsed = JSON.parse(errorText);
      const apiMessage = parsed?.error?.message;
      const apiCode = parsed?.error?.code;
      if (typeof apiMessage === "string" && apiMessage.trim().length > 0) {
        safeMessage = apiMessage.trim().slice(0, 500);
      }
      if (typeof apiCode === "string" && apiCode.trim().length > 0) {
        safeCode = apiCode.trim().slice(0, 120);
      }
    } catch (_) {
      // Keep generic provider error.
    }

    throw new Error("provider_error:" + safeCode + ":" + safeMessage);
  }

  const data = await response.json();
  const inputRaw = Number(data?.usage?.input_tokens ?? 0);
  const outputRaw = Number(data?.usage?.output_tokens ?? 0);

  return {
    provider,
    model,
    data,
    inputUnits: Number.isFinite(inputRaw) && inputRaw > 0 ? inputRaw : null,
    outputUnits: Number.isFinite(outputRaw) && outputRaw > 0 ? outputRaw : null,
  };
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") return reply({ error: "method_not_allowed" }, 405);

  const authorization = req.headers.get("Authorization");
  if (!authorization) return reply({ error: "unauthorized" }, 401);

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    { global: { headers: { Authorization: authorization } } },
  );

  const { data: authData, error: authError } = await supabase.auth.getUser();
  const user = authData?.user;
  if (authError || !user) return reply({ error: "unauthorized" }, 401);

  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!serviceRoleKey) {
    return reply({ error: "server_configuration_error" }, 503);
  }

  const admin = createClient(
    Deno.env.get("SUPABASE_URL")!,
    serviceRoleKey,
    { auth: { persistSession: false, autoRefreshToken: false } },
  );

  let body: any;
  try {
    body = await req.json();
  } catch (_) {
    return reply({ error: "invalid_json" }, 400);
  }

  const title = String(body?.title ?? "Generated Study Set").trim().slice(0, 120);
  const sourceType = String(body?.source_type ?? "notes");
  const sourceText = String(body?.source_text ?? "").trim();
  const sourcePath = String(body?.source_path ?? "").trim();
  const sourceName = String(body?.source_name ?? "").trim().slice(0, 180);
  const mimeType = String(body?.mime_type ?? "").trim();
  const mode = String(body?.mode ?? "mixed");
  const requestedCount = Number(body?.question_count ?? 10);
  const topicTag = String(body?.topic_tag ?? "").trim().slice(0, 100);

  const allowedModes = new Set(["multiple_choice","true_false","identification","flashcards","mixed"]);
  const allowedCounts = new Set([5,10,20,40]);
  const allowedSources = new Set(["notes","pdf","docx","pptx","image","text"]);

  if (!allowedModes.has(mode)) return reply({ error: "invalid_mode" }, 400);
  if (!allowedCounts.has(requestedCount)) return reply({ error: "invalid_question_count" }, 400);
  if (!allowedSources.has(sourceType)) return reply({ error: "invalid_source_type" }, 400);
  if (sourceType === "notes" && sourceText.length < 80) {
    return reply({ error: "source_too_short", message: "Add more source material before generating questions." }, 400);
  }
  if (sourceType === "notes" && sourceText.length > 60000) {
    return reply({ error: "source_too_long", message: "Keep pasted source material under 60,000 characters." }, 400);
  }
  if (sourceType !== "notes" && !sourcePath) {
    return reply({ error: "missing_source_file" }, 400);
  }
  if (sourcePath && !sourcePath.startsWith(user.id + "/")) {
    return reply({ error: "invalid_source_path" }, 403);
  }

  const sourceIdentity = sourceType === "notes" ? sourceText : sourcePath;
  const sourceHash = await sha256Hex(sourceIdentity);
  const cacheKey = await sha256Hex(JSON.stringify({
    schema: 1,
    source_type: sourceType,
    source_hash: sourceHash,
    mode,
    requested_count: requestedCount,
    topic_tag: topicTag,
  }));

  const requestStartedAt = Date.now();

  const { data: cached } = await admin
    .from("ai_generation_cache")
    .select("id,provider,model,payload,hit_count")
    .eq("owner_user_id", user.id)
    .eq("cache_key", cacheKey)
    .maybeSingle();

  if (cached?.payload && Array.isArray(cached.payload.questions)) {
    const cachedPayload = cached.payload;
    const { data: cachedSet, error: cachedSetError } = await supabase
      .from("study_sets")
      .insert({
        user_id: user.id,
        title: String(cachedPayload.title ?? title).trim().slice(0, 120) || title,
        source_type: sourceType === "text" ? "notes" : sourceType,
        source_name: sourceName || (sourceType === "notes" ? "Pasted notes" : null),
        source_text: sourceType === "notes" ? sourceText : null,
        source_path: sourcePath || null,
        generation_mode: mode,
        requested_count: requestedCount,
        status: "ready",
        topic_tag: String(cachedPayload.topic_tag ?? topicTag).trim().slice(0, 100) || null,
        ai_model: cached.model,
      })
      .select("id")
      .single();

    if (cachedSetError || !cachedSet) {
      return reply({ error: "study_set_create_failed" }, 500);
    }

    const cachedQuestions = cachedPayload.questions
      .slice(0, requestedCount)
      .map((q: any, index: number) => ({
        study_set_id: cachedSet.id,
        position: index,
        kind: q.kind,
        prompt: q.prompt,
        options: q.options ?? [],
        correct_values: q.correct_values ?? [],
        explanation: q.explanation ?? "",
        source_excerpt: q.source_excerpt ?? "",
        topic_tag: q.topic_tag ?? null,
        difficulty: q.difficulty ?? "foundation",
      }));

    const { error: cachedQuestionError } = await supabase
      .from("study_questions")
      .insert(cachedQuestions);

    if (cachedQuestionError) {
      await supabase.from("study_sets").delete().eq("id", cachedSet.id);
      return reply({ error: "question_save_failed" }, 500);
    }

    await admin
      .from("ai_generation_cache")
      .update({
        hit_count: Number(cached.hit_count ?? 0) + 1,
        last_hit_at: new Date().toISOString(),
      })
      .eq("id", cached.id);

    await admin.from("ai_generation_requests").insert({
      user_id: user.id,
      request_kind: "study_generation",
      source_hash: sourceHash,
      provider: cached.provider,
      model: cached.model,
      status: "cache_hit",
      cache_hit: true,
      study_set_id: cachedSet.id,
      latency_ms: Date.now() - requestStartedAt,
    });

    return reply({
      study_set_id: cachedSet.id,
      generated_count: cachedQuestions.length,
      requested_count: requestedCount,
      cache_hit: true,
      ai_credits_used: 0,
    });
  }

  const { data: creditResult, error: creditError } = await admin.rpc(
    "consume_ai_credit_for_user",
    {
      p_user_id: user.id,
      p_kind: "generation",
      p_cost: 1,
    },
  );

  if (creditError) {
    return reply({ error: "quota_check_failed" }, 503);
  }

  if (!creditResult?.allowed) {
    await admin.from("ai_generation_requests").insert({
      user_id: user.id,
      request_kind: "study_generation",
      source_hash: sourceHash,
      status: "rejected",
      cache_hit: false,
      error_code: "daily_ai_limit_reached",
      error_message: "Daily AI generation limit reached.",
      latency_ms: Date.now() - requestStartedAt,
    });

    return reply({
      error: "daily_ai_limit_reached",
      message: "Your daily AI generation limit has been reached.",
      quota: creditResult,
    }, 429);
  }

  const { data: setRow, error: setError } = await supabase
    .from("study_sets")
    .insert({
      user_id: user.id,
      title,
      source_type: sourceType === "text" ? "notes" : sourceType,
      source_name: sourceName || (sourceType === "notes" ? "Pasted notes" : null),
      source_text: sourceType === "notes" ? sourceText : null,
      source_path: sourcePath || null,
      generation_mode: mode,
      requested_count: requestedCount,
      status: "generating",
      topic_tag: topicTag || null,
    })
    .select("id")
    .single();

  if (setError || !setRow) return reply({ error: "study_set_create_failed" }, 500);

  const studySetId = setRow.id;

  const formatInstructions: Record<string,string> = {
    multiple_choice: "Create only single_select questions with exactly four options.",
    true_false: "Create only true_false questions with exactly two options: True and False.",
    identification: "Create only identification questions requiring a short exact answer.",
    flashcards: "Create only flashcards: prompt is the front, correct_values contains the concise back.",
    mixed: "Use a useful mixture of single_select, true_false, identification, and flashcard items.",
  };

  const systemPrompt = [
    "You generate study practice for Norie Learning.",
    "Use ONLY facts explicitly supported by the supplied source material.",
    "Do not add outside facts, corrections, assumptions, or inferred details.",
    "If the source does not support enough distinct questions, return fewer items rather than inventing content.",
    "Every explanation and source_excerpt must be supported by the source.",
    "source_excerpt must be a short exact excerpt from the source, at most 25 words.",
    "Avoid duplicate questions.",
    "For single_select, use exactly four choices and exactly one correct value.",
    "For true_false, options must be [\"True\", \"False\"].",
    "For identification and flashcard, options must be an empty array.",
    formatInstructions[mode],
    "Return JSON only in this shape:",
    "{\"title\":\"string\",\"topic_tag\":\"string\",\"questions\":[{\"kind\":\"single_select|true_false|identification|flashcard\",\"prompt\":\"string\",\"options\":[\"string\"],\"correct_values\":[\"string\"],\"explanation\":\"string\",\"source_excerpt\":\"string\",\"topic_tag\":\"string\",\"difficulty\":\"foundation|intermediate|advanced\"}]}",
  ].join("\n");

  const instructions = [
    "Create up to " + requestedCount + " items.",
    "Requested mode: " + mode + ".",
    topicTag ? "Topic tag hint: " + topicTag + "." : "",
  ].filter(Boolean).join("\n");

  const userContent: any[] = [{ type: "input_text", text: instructions }];

  if (sourceType === "notes") {
    userContent.push({ type: "input_text", text: "SOURCE MATERIAL:\n" + sourceText });
  } else {
    const { data: blob, error: downloadError } = await supabase.storage.from(bucket).download(sourcePath);
    if (downloadError || !blob) {
      await supabase.from("study_sets").update({ status: "failed", error_message: "Source file could not be loaded." }).eq("id", studySetId);
      return reply({ error: "source_download_failed" }, 422);
    }

    const bytes = new Uint8Array(await blob.arrayBuffer());
    const mime = sourceMime(sourceType, sourceName, mimeType);
    const base64 = bytesToBase64(bytes);

    if (sourceType === "image") {
      userContent.push({
        type: "input_image",
        image_url: "data:" + mime + ";base64," + base64,
        detail: "high",
      });
    } else {
      const item: any = {
        type: "input_file",
        filename: sourceName || "study-source",
        file_data: "data:" + mime + ";base64," + base64,
      };
      if (mime === "application/pdf") item.detail = "low";
      userContent.push(item);
    }
  }

  try {
    const providerResult = await callAiProvider({
      systemPrompt,
      userContent,
    });
    const { provider, model, data, inputUnits, outputUnits } = providerResult;
    const generated = JSON.parse(extractJsonObject(extractOutputText(data).trim()));
    const inputQuestions = Array.isArray(generated?.questions) ? generated.questions : [];

    const questions: any[] = [];
    for (const q of inputQuestions.slice(0, requestedCount)) {
      const kind = String(q?.kind ?? "");
      if (!["single_select","true_false","identification","flashcard"].includes(kind)) continue;

      const prompt = String(q?.prompt ?? "").trim();
      const explanation = String(q?.explanation ?? "").trim();
      const sourceExcerpt = String(q?.source_excerpt ?? "").trim();
      const options = Array.isArray(q?.options) ? q.options.map((x: unknown) => String(x)) : [];
      const correctValues = Array.isArray(q?.correct_values) ? q.correct_values.map((x: unknown) => String(x)) : [];

      if (!prompt || correctValues.length === 0 || !sourceExcerpt) continue;
      if (kind === "single_select" && options.length !== 4) continue;
      if (kind === "true_false" && options.length !== 2) continue;
      if ((kind === "identification" || kind === "flashcard") && options.length !== 0) continue;

      questions.push({
        study_set_id: studySetId,
        position: questions.length,
        kind,
        prompt,
        options,
        correct_values: correctValues,
        explanation,
        source_excerpt: sourceExcerpt,
        topic_tag: String(q?.topic_tag ?? topicTag ?? "").trim() || null,
        difficulty: ["foundation","intermediate","advanced"].includes(String(q?.difficulty)) ? String(q.difficulty) : "foundation",
      });
    }

    if (questions.length === 0) {
      await supabase.from("study_sets").update({
        status: "failed",
        error_message: "The source did not support usable questions.",
        ai_model: model,
      }).eq("id", studySetId);
      return reply({ error: "no_supported_questions", message: "The source did not support enough grounded questions." }, 422);
    }

    const { error: questionError } = await supabase.from("study_questions").insert(questions);
    if (questionError) {
      await supabase.from("study_sets").update({
        status: "failed",
        error_message: "Generated questions could not be saved.",
        ai_model: model,
      }).eq("id", studySetId);
      return reply({ error: "question_save_failed" }, 500);
    }

    const finalTitle = String(generated?.title ?? title).trim().slice(0, 120) || title;
    const finalTopicTag =
      String(generated?.topic_tag ?? topicTag).trim().slice(0, 100) || null;

    await supabase.from("study_sets").update({
      title: finalTitle,
      topic_tag: finalTopicTag,
      status: "ready",
      ai_model: model,
      error_message: null,
    }).eq("id", studySetId);

    const cachePayload = {
      title: finalTitle,
      topic_tag: finalTopicTag,
      questions: questions.map((q) => ({
        kind: q.kind,
        prompt: q.prompt,
        options: q.options,
        correct_values: q.correct_values,
        explanation: q.explanation,
        source_excerpt: q.source_excerpt,
        topic_tag: q.topic_tag,
        difficulty: q.difficulty,
      })),
    };

    await admin.from("ai_generation_cache").upsert({
      owner_user_id: user.id,
      cache_key: cacheKey,
      task_type: "study_generation",
      provider,
      model,
      payload: cachePayload,
      last_hit_at: null,
    }, { onConflict: "owner_user_id,cache_key" });

    const { data: requestRow } = await admin
      .from("ai_generation_requests")
      .insert({
        user_id: user.id,
        request_kind: "study_generation",
        source_hash: sourceHash,
        provider,
        model,
        status: "success",
        cache_hit: false,
        study_set_id: studySetId,
        latency_ms: Date.now() - requestStartedAt,
        input_units: inputUnits,
        output_units: outputUnits,
      })
      .select("id")
      .single();

    if (requestRow?.id) {
      await admin.from("ai_evaluation_records").insert({
        user_id: user.id,
        generation_request_id: requestRow.id,
        study_set_id: studySetId,
        validation_status: questions.length >= requestedCount ? "passed" : "partial",
        generated_items: questions.length,
        rejected_items: Math.max(inputQuestions.slice(0, requestedCount).length - questions.length, 0),
        grounded_items: questions.length,
      });
    }

    return reply({
      study_set_id: studySetId,
      generated_count: questions.length,
      requested_count: requestedCount,
      cache_hit: false,
      ai_credits_used: 1,
    });
  } catch (error) {
    const rawMessage = error instanceof Error ? error.message : "Unknown error";
    let errorCode = "generation_failed";
    let safeMessage = "Generation could not be completed.";
    let provider: string | null = null;
    let model: string | null = null;

    if (rawMessage === "ai_not_configured") {
      errorCode = "ai_not_configured";
      safeMessage = "The Norie AI provider is not configured yet.";
    } else if (rawMessage.startsWith("provider_not_configured:")) {
      errorCode = "provider_not_configured";
      provider = rawMessage.split(":")[1] || null;
      safeMessage = "The selected Norie AI provider is not configured yet.";
    } else if (rawMessage.startsWith("provider_error:")) {
      const parts = rawMessage.split(":");
      errorCode = parts[1] || "ai_request_failed";
      safeMessage = parts.slice(2).join(":").slice(0, 500) ||
        "The AI provider rejected the generation request.";
      provider = (Deno.env.get("NORIE_AI_PROVIDER") || "openai").trim().toLowerCase();
      model = provider === "openai"
        ? (Deno.env.get("OPENAI_MODEL") || "gpt-5.6-luna")
        : null;
    }

    await admin.rpc("refund_ai_credit_for_user", {
      p_user_id: user.id,
      p_kind: "generation",
      p_cost: 1,
    });

    await supabase.from("study_sets").update({
      status: "failed",
      error_message: safeMessage,
      ai_model: model,
    }).eq("id", studySetId);

    await admin.from("ai_generation_requests").insert({
      user_id: user.id,
      request_kind: "study_generation",
      source_hash: sourceHash,
      provider,
      model,
      status: "failed",
      cache_hit: false,
      study_set_id: studySetId,
      latency_ms: Date.now() - requestStartedAt,
      error_code: errorCode,
      error_message: safeMessage,
    });

    const status = errorCode === "ai_not_configured" ||
        errorCode === "provider_not_configured"
      ? 503
      : 502;

    return reply({
      error: errorCode,
      message: safeMessage,
    }, status);
  }
});
