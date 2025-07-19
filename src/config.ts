export const SITE = {
  website: "https://antoniovigilante.pages.dev/", // replace this with your deployed domain
  author: "Antonio Vigilante",
  profile: "https://antoniovigilante.pages.dev/",
  desc: "Blog di Antonio Vigilante.",
  title: "🅰ttraversamenti",
  ogImage: "astropaper-og.jpg",
  lightAndDarkMode: true,
  postPerIndex: 3,
  postPerPage:3,
  scheduledPostMargin: 15 * 60 * 1000, // 15 minutes
  showArchives: true,
  showBackButton: false, // show back button in post detail
  editPost: {
    enabled: true,
    text: "Modifica",
    url: "https://github.com/antonio-vigilante/blog/edit/main/",
  },
  dynamicOgImage: true,
  dir: "ltr", // "rtl" | "auto"
  lang: "it", // html lang code. Set this empty and default will be "en"
  timezone: "Europe/Rome", // Default global timezone (IANA format) https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
} as const;
