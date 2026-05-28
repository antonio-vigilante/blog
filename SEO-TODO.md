# SEO — Interventi suggeriti

## 1. Schema `Person` sulla pagina `/about`

Aggiungere un blocco JSON-LD in `AboutLayout.astro` per dichiarare esplicitamente a Google chi è l'autore del sito. Esempio da inserire nel `<head>` tramite Layout:

```json
{
  "@context": "https://schema.org",
  "@type": "Person",
  "name": "Antonio Vigilante",
  "url": "https://www.odnikud.it/about",
  "sameAs": [
    "https://poliversity.it/@antoniovigilante",
    "https://github.com/antonio-vigilante",
    "https://www.micromega.net/author/antonio-vigilante",
    "https://laricerca.loescher.it/autori/vigilante/",
    "https://www.glistatigenerali.com/author/naciketas/"
  ]
}
```

Il campo `sameAs` è molto efficace: dice a Google che tutte quelle pagine si riferiscono alla stessa persona, consolidando l'autorità del nome.

## 2. Aggiungere `description` al frontmatter di `/about`

`AboutLayout.astro` accetta un campo `description` ma `about.md` non lo dichiara,
quindi la pagina usa la descrizione generica del sito. Aggiungere:

```yaml
description: "Antonio Vigilante, filosofo e pedagogista. Tutor coordinatore di Filosofia e Scienze Umane all'Università di Siena. Autore, direttore di Educazione Aperta."
```

## 3. Google Search Console

- Verificare che il sito sia registrato con il dominio **`www.odnikud.it`** (non `antoniovigilante.pages.dev`)
- Dopo il prossimo deploy, richiedere reindicizzazione di `/`, `/about`, `/libri`
- Controllare la sezione **Miglioramenti > Dati strutturati** per verificare che gli errori di `BlogPosting` con `datePublished: undefined` siano spariti

## 4. Backlink da pagine ad alta autorità

Google già trova "Antonio Vigilante" su MicroMega, Gli Stati Generali, Loescher ecc., ma nessuna di quelle pagine collega a `odnikud.it`. Anche un solo link da `micromega.net` o `laricerca.loescher.it` nella bio dell'autore avrebbe un impatto significativo sul ranking.

## 5. Titolo homepage più esplicito (opzionale)

Attualmente la homepage ha come `<title>` solo `Odnikud`. Valutare se cambiare `SITE.title` in `config.ts` oppure sovrascrivere il titolo nella homepage con qualcosa come `"Odnikud — Blog di Antonio Vigilante"`. Questo aiuta Google ad associare il dominio al nome dell'autore senza aspettare che indicizzi il contenuto della pagina.
