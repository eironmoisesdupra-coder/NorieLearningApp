import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

function reply(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") return reply({ error: "method_not_allowed" }, 405);

  const authorization = req.headers.get("Authorization");
  if (!authorization) return reply({ error: "unauthorized" }, 401);

  let body: any;
  try {
    body = await req.json();
  } catch (_) {
    return reply({ error: "invalid_json" }, 400);
  }

  const action = String(body?.action ?? "").trim();
  const payload = body?.payload && typeof body.payload === "object"
    ? body.payload
    : {};

  const routes: Record<string, string> = {
    generate_study_set: "generate-study-set",
    study_qa: "study-qa",
  };

  const functionName = routes[action];
  if (!functionName) {
    return reply({
      error: "unsupported_ai_action",
      message: "This Norie AI action is not supported.",
    }, 400);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
  if (!supabaseUrl || !anonKey) {
    return reply({ error: "server_configuration_error" }, 503);
  }

  try {
    const upstream = await fetch(
      supabaseUrl + "/functions/v1/" + functionName,
      {
        method: "POST",
        headers: {
          "Authorization": authorization,
          "apikey": anonKey,
          "Content-Type": "application/json",
          "x-norie-ai-gateway": "1",
        },
        body: JSON.stringify(payload),
      },
    );

    const text = await upstream.text();
    let data: unknown;
    try {
      data = JSON.parse(text);
    } catch (_) {
      data = {
        error: "invalid_upstream_response",
        message: "Norie AI received an invalid internal response.",
      };
    }

    return reply(data, upstream.status);
  } catch (error) {
    console.error("Norie AI gateway upstream failure", error);
    return reply({
      error: "ai_gateway_unavailable",
      message: "Norie AI is temporarily unavailable.",
    }, 503);
  }
});
