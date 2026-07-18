export interface Book {
  title: string;
  image: string;
  url: string;
}

// Ordine: dal più recente al meno recente.
export const books: Book[] = [
  {
    title: "Textus. Manuale pratico di didattica digitale della filosofia",
    image: "/images/libri/textus.jpg",
    url: "https://zenodo.org/records/19975665",
  },
  {
    title: "Senza cattedra. La scuola possibile",
    image: "/images/libri/senzacattedra.jpg",
    url: "/posts/2026-01-28-senza-cattedra/",
  },
  {
    title: "La stanza di fronte. Tre saggi di filosofia interculturale",
    image: "/images/libri/lastanzadifronte.jpg",
    url: "https://www.ledizioni.it/prodotto/la-stanza-di-fronte/",
  },
  {
    title: "Le dimore leggere. Saggio sull'etica buddhista",
    image: "/images/libri/dimoreleggere.jpg",
    url: "/posts/2021-07-27-le-dimore-leggere/",
  },
];
