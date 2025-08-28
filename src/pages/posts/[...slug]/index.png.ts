import type { APIRoute } from "astro";
import { getCollection, type CollectionEntry } from "astro:content";
import { getPath } from "@/utils/getPath";
import { generateOgImageForPost } from "@/utils/generateOgImages";
import { SITE } from "@/config";

// Genera le route statiche per le immagini OG dei post
export async function getStaticPaths() {
  if (!SITE.dynamicOgImage) return [];

  const posts = await getCollection("blog").then((p) =>
    p.filter(({ data }) => !data.draft && !data.ogImage)
  );

  return posts.map((post) => ({
    params: { slug: getPath(post.id, post.filePath, false) },
    props: post,
  }));
}

// Serve l'immagine OG del singolo post
export const GET: APIRoute = async ({ props }) => {
  if (!SITE.dynamicOgImage) {
    return new Response(null, { status: 404, statusText: "Not found" });
  }

  const png = await generateOgImageForPost(props as CollectionEntry<"blog">); // Buffer | Uint8Array

  const bytes = png instanceof Uint8Array
    ? png
    : new Uint8Array(png as unknown as ArrayLike<number>);

  const ab = new ArrayBuffer(bytes.byteLength);
  new Uint8Array(ab).set(bytes);

  return new Response(ab, {
    headers: {
      "Content-Type": "image/png",
      "Cache-Control": "public, max-age=604800, immutable",
    },
  });
};

