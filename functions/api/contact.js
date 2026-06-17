export async function onRequestPost(context) {
  const { request, env } = context;

  const formData = await request.formData();
  const name = formData.get("name")?.toString().trim() ?? "";
  const email = formData.get("email")?.toString().trim() ?? "";
  const message = formData.get("message")?.toString().trim() ?? "";
  const publish = formData.get("publish") === "on" ? "Sì" : "No";
  const honeypot = formData.get("website")?.toString() ?? "";

  // Honeypot anti-spam
  if (honeypot) {
    return new Response(JSON.stringify({ success: true }), { status: 200 });
  }

  if (!name || !email || !message) {
    return new Response(
      JSON.stringify({ error: "Tutti i campi sono obbligatori." }),
      { status: 400, headers: { "Content-Type": "application/json" } }
    );
  }

  const res = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${env.RESEND_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      from: "Odnikud <onboarding@resend.dev>",
      to: "rimarerum@gmail.com",
      subject: `Messaggio da ${name}`,
      text: `Nome: ${name}\nEmail: ${email}\nAutorizza pubblicazione: ${publish}\n\n${message}`,
      reply_to: email,
    }),
  });

  if (!res.ok) {
    const resendError = await res.json().catch(() => ({}));
    console.error("Resend error:", JSON.stringify(resendError));
    return new Response(
      JSON.stringify({ error: resendError.message ?? "Errore nell'invio. Riprova più tardi." }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }

  return new Response(JSON.stringify({ success: true }), {
    status: 200,
    headers: { "Content-Type": "application/json" },
  });
}
