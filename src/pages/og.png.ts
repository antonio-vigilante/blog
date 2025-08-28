import type { APIRoute } from "astro";
import { generateOgImageForSite } from "@/utils/generateOgImages";

export const GET: APIRoute = async () => {
  const png = await generateOgImageForSite(); // Buffer | Uint8Array

  // Normalizza a Uint8Array
  const bytes = png instanceof Uint8Array
    ? png
    : new Uint8Array(png as unknown as ArrayLike<number>);

  // Crea un ArrayBuffer nuovo (evita SharedArrayBuffer e offset vari)
  const ab = new ArrayBuffer(bytes.byteLength);
  new Uint8Array(ab).set(bytes);

  return new Response(ab, {
    headers: {
      "Content-Type": "image/png",
      "Cache-Control": "public, max-age=604800, immutable",
    },
  });
};


