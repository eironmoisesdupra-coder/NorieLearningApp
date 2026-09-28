import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

function reply(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
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

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") return reply({ error: "method_not_allowed" }, 405);

  const authorization = req.headers.get("Authorization");
  if (!authorization) return reply({ error: "unauthorized" }, 401);

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    { global: { headers: { Authorization: authorization } } },
  );

  const { data: authData, error: authError } = await supabase.auth.getUser();
  if (authError || !authData?.user) return reply({ error: "unauthorized" }, 401);

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
    .select("title,source_text,topic_tag")
    .eq("id", studySetId)
    .maybeSingle();

  if (setError || !setRow) return reply({ error: "study_set_not_found" }, 404);

  const source = String(setRow.source_text ?? "").trim();
  if (!source) return reply({ error: "source_unavailable" }, 422);

  const model = Deno.env.get("OPENAI_MODEL") || "gpt-5.6-luna";

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
              "Answer ONLY from the supplied SOURCE MATERIAL.",
              "Do not silently correct or supplement the source with outside knowledge.",
              "If the source does not support the answer, say exactly: The uploaded source does not provide enough information to answer that.",
              "Keep the explanation clear and concise for a learner.",
            ].join("\n"),
          }],
        },
        {
          role: "user",
          content: [{
            type: "input_text",
            text: "QUESTION:\n" + question + "\n\nSOURCE MATERIAL:\n" + source,
          }],
        },
      ],
    }),
  });

  if (!openAiRes.ok) return reply({ error: "ai_request_failed" }, 502);

  const data = await openAiRes.json();
  const answer = extractOutputText(data).trim();
  if (!answer) return reply({ error: "empty_answer" }, 502);

  return reply({ answer, model });
});
