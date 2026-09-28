import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const bucket = "study-sources";

function reply(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
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

function bytesToBase64(bytes: Uint8Array): string {
  let binary = "";
  const chunk = 0x8000;
  for (let i = 0; i < bytes.length; i += chunk) {
    binary += String.fromCharCode(...bytes.subarray(i, i + chunk));
  }
  return btoa(binary);
}

function sourceMime(filename: string): string {
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
  return "image/jpeg";
}

async function sha256Hex(value: string): Promise<string> {
  const bytes = new TextEncoder().encode(value);
  const digest = await crypto.subtle.digest("SHA-256", bytes);
  return Array.from(new Uint8Array(digest))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

async function callAiProvider(userContent: any[]): Promise<{
  provider: string;
  model: string;
  data: any;
  inputUnits: number | null;
  outputUnits: number | null;
}> {
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
        {
          role: "system",
          content: [{
            type: "input_text",
            text: [
              "You are Norie, a study assistant.",
              "Answer ONLY from the supplied source material.",
              "Do not silently correct or supplement the source with outside knowledge.",
              "If the source does not support the answer, say exactly: The uploaded source does not provide enough information to answer that.",
              "Keep explanations clear and concise for a learner.",
            ].join("\n"),
          }],
        },
        { role: "user", content: userContent },
      ],
    }),
  });

  if (!response.ok) {
    const errorText = await response.text();
    console.error("AI provider error", provider, response.status, errorText.slice(0, 1000));
    let code = "ai_request_failed";
    let message = "The AI provider rejected this question.";
    try {
      const parsed = JSON.parse(errorText);
      if (typeof parsed?.error?.code === "string" && parsed.error.code.trim()) {
        code = parsed.error.code.trim().slice(0, 120);
      }
      if (typeof parsed?.error?.message === "string" && parsed.error.message.trim()) {
        message = parsed.error.message.trim().slice(0, 500);
      }
    } catch (_) {
      // Keep generic provider error.
    }
    throw new Error("provider_error:" + code + ":" + message);
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
  if (!serviceRoleKey) return reply({ error: "server_configuration_error" }, 503);

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

  const studySetId = String(body?.study_set_id ?? "");
  const question = String(body?.question ?? "").trim();

  if (!studySetId || question.length < 2 || question.length > 1000) {
    return reply({ error: "invalid_request" }, 400);
  }

  const { data: setRow, error: setError } = await supabase
    .from("study_sets")
    .select("title,source_type,source_name,source_text,source_path,topic_tag")
    .eq("id", studySetId)
    .maybeSingle();

  if (setError || !setRow) return reply({ error: "study_set_not_found" }, 404);

  const requestStartedAt = Date.now();
  const userContent: any[] = [{
    type: "input_text",
    text: "QUESTION:\n" + question,
  }];

  const sourceText = String(setRow.source_text ?? "").trim();
  const sourcePath = String(setRow.source_path ?? "").trim();
  const sourceName = String(setRow.source_name ?? "study-source");
  const sourceType = String(setRow.source_type ?? "notes");

  if (sourceText) {
    userContent.push({
      type: "input_text",
      text: "SOURCE MATERIAL:\n" + sourceText,
    });
  } else if (sourcePath) {
    if (!sourcePath.startsWith(user.id + "/")) {
      return reply({ error: "invalid_source_path" }, 403);
    }

    const { data: blob, error: downloadError } =
      await supabase.storage.from(bucket).download(sourcePath);
    if (downloadError || !blob) return reply({ error: "source_unavailable" }, 422);

    const bytes = new Uint8Array(await blob.arrayBuffer());
    const mime = sourceMime(sourceName);
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
        filename: sourceName,
        file_data: "data:" + mime + ";base64," + base64,
      };
      if (mime === "application/pdf") item.detail = "low";
      userContent.push(item);
    }
  } else {
    return reply({ error: "source_unavailable" }, 422);
  }

  const sourceHash = await sha256Hex(sourceText || sourcePath);

  const { data: creditResult, error: creditError } = await admin.rpc(
    "consume_ai_credit_for_user",
    {
      p_user_id: user.id,
      p_kind: "qa",
      p_cost: 1,
    },
  );

  if (creditError) return reply({ error: "quota_check_failed" }, 503);

  if (!creditResult?.allowed) {
    await admin.from("ai_generation_requests").insert({
      user_id: user.id,
      request_kind: "study_qa",
      source_hash: sourceHash,
      status: "rejected",
      cache_hit: false,
      study_set_id: studySetId,
      latency_ms: Date.now() - requestStartedAt,
      error_code: "daily_qa_limit_reached",
      error_message: "Daily source Q&A limit reached.",
    });

    return reply({
      error: "daily_qa_limit_reached",
      message: "Your daily Ask Norie limit has been reached.",
      quota: creditResult,
    }, 429);
  }

  try {
    const providerResult = await callAiProvider(userContent);
    const answer = extractOutputText(providerResult.data).trim();

    if (!answer) {
      throw new Error("empty_answer");
    }

    await admin.from("ai_generation_requests").insert({
      user_id: user.id,
      request_kind: "study_qa",
      source_hash: sourceHash,
      provider: providerResult.provider,
      model: providerResult.model,
      status: "success",
      cache_hit: false,
      study_set_id: studySetId,
      latency_ms: Date.now() - requestStartedAt,
      input_units: providerResult.inputUnits,
      output_units: providerResult.outputUnits,
    });

    return reply({
      answer,
      model: providerResult.model,
      provider: providerResult.provider,
      ai_credits_used: 1,
    });
  } catch (error) {
    const rawMessage = error instanceof Error ? error.message : "Unknown error";
    let errorCode = "study_qa_failed";
    let safeMessage = "Norie could not answer from this source right now.";
    let provider: string | null = null;
    let model: string | null = null;

    if (rawMessage === "ai_not_configured") {
      errorCode = "ai_not_configured";
      safeMessage = "The Norie AI provider is not configured yet.";
    } else if (rawMessage === "empty_answer") {
      errorCode = "empty_answer";
      safeMessage = "The AI provider returned an empty answer.";
    } else if (rawMessage.startsWith("provider_not_configured:")) {
      errorCode = "provider_not_configured";
      provider = rawMessage.split(":")[1] || null;
      safeMessage = "The selected Norie AI provider is not configured yet.";
    } else if (rawMessage.startsWith("provider_error:")) {
      const parts = rawMessage.split(":");
      errorCode = parts[1] || "ai_request_failed";
      safeMessage = parts.slice(2).join(":").slice(0, 500) ||
        "The AI provider rejected this question.";
      provider = (Deno.env.get("NORIE_AI_PROVIDER") || "openai").trim().toLowerCase();
      model = provider === "openai"
        ? (Deno.env.get("OPENAI_MODEL") || "gpt-5.6-luna")
        : null;
    }

    await admin.rpc("refund_ai_credit_for_user", {
      p_user_id: user.id,
      p_kind: "qa",
      p_cost: 1,
    });

    await admin.from("ai_generation_requests").insert({
      user_id: user.id,
      request_kind: "study_qa",
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
