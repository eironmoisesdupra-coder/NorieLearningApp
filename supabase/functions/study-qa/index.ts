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

  const apiKey = Deno.env.get("OPENAI_API_KEY");
  if (!apiKey) return reply({ error: "ai_not_configured" }, 503);

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

  const model = Deno.env.get("OPENAI_MODEL") || "gpt-5.6-luna";
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

  const openAiRes = await fetch("https://api.openai.com/v1/responses", {
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

  if (!openAiRes.ok) return reply({ error: "ai_request_failed" }, 502);

  const data = await openAiRes.json();
  const answer = extractOutputText(data).trim();
  if (!answer) return reply({ error: "empty_answer" }, 502);

  return reply({ answer, model });
});
