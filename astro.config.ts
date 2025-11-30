// astro.config.ts
import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";
import tailwindcss from "@tailwindcss/vite";
import remarkToc from "remark-toc";
import remarkCollapse from "remark-collapse";

import {
  transformerNotationDiff,
  transformerNotationHighlight,
  transformerNotationWordHighlight,
} from "@shikijs/transformers";

import { transformerFileName } from "./src/utils/transformers/fileName";

import mdx from "@astrojs/mdx";

export default defineConfig({
  site: "https://antoniovigilante.pages.dev",

  // ⭐ Unico blocco corretto
  integrations: [sitemap({
    entryLimit: 45000,
    // filter: (page) => !page.endsWith("/archives"), // opzionale
  }), mdx()],

  markdown: {
    remarkPlugins: [
      remarkToc,
      [remarkCollapse, { test: "Table of contents" }],
    ],
    shikiConfig: {
      themes: { light: "min-light", dark: "night-owl" },
      defaultColor: false,
      wrap: false,
      transformers: [
        transformerFileName({ style: "v2", hideDot: false }),
        transformerNotationHighlight(),
        transformerNotationWordHighlight(),
        transformerNotationDiff({ matchAlgorithm: "v3" }),
      ],
    },
  },

  vite: {
    plugins: [tailwindcss()],
    optimizeDeps: { exclude: ["@resvg/resvg-js"] },
  },

  image: {
    responsiveStyles: true,
    layout: "constrained",
  },

  experimental: {
    preserveScriptOrder: true,
  },
});