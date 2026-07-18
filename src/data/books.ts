export interface Book {
  title: string;
  image: string;
  publisher: string;
  year: number;
  url: string;
}

// Ordine: dal più recente al meno recente.
export const books: Book[] = [
  {
    title: "Textus. Manuale pratico di didattica digitale della filosofia",
    image: "/images/libri/textus.jpg",
    publisher: "Zenodo",
    year: 2026,
    url: "https://zenodo.org/records/19975665",
  },
  {
    title: "Senza cattedra. La scuola possibile",
    image: "/images/libri/senzacattedra.jpg",
    publisher: "Loescher",
    year: 2026,
    url: "/posts/2026-01-28-senza-cattedra/",
  },
  {
    title: "La stanza di fronte. Tre saggi di filosofia interculturale",
    image: "/images/libri/lastanzadifronte.jpg",
    publisher: "Ledizioni",
    year: 2024,
    url: "https://www.ledizioni.it/prodotto/la-stanza-di-fronte/",
  },
  {
    title: "Le dimore leggere. Saggio sull'etica buddhista",
    image: "/images/libri/dimoreleggere.jpg",
    publisher: "Petite Plaisance",
    year: 2021,
    url: "/posts/2021-07-27-le-dimore-leggere/",
  },
];
