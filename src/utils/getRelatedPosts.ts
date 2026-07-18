import type { CollectionEntry } from "astro:content";

const getRelatedPosts = (
  post: CollectionEntry<"blog">,
  posts: CollectionEntry<"blog">[],
  limit = 4
) => {
  const tags = new Set(post.data.tags);

  return posts
    .filter(p => p.id !== post.id)
    .map(p => ({
      post: p,
      shared: p.data.tags.filter(tag => tags.has(tag)).length,
    }))
    .filter(({ shared }) => shared > 0)
    .sort((a, b) => {
      if (b.shared !== a.shared) return b.shared - a.shared;
      return (
        new Date(b.post.data.pubDatetime).getTime() -
        new Date(a.post.data.pubDatetime).getTime()
      );
    })
    .slice(0, limit)
    .map(({ post }) => post);
};

export default getRelatedPosts;
