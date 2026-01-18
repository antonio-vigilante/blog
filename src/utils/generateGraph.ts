// src/utils/generateGraph.ts
import { getCollection } from 'astro:content';

export async function generateGraphData() {
  const posts = await getCollection('blog');
  
  const nodes = posts.map(post => ({
    id: post.slug,
    name: post.data.title,
    val: 5
  }));
  
  // Analizza i link interni per creare le connessioni
  const links = []; // Logica per estrarre i link
  
  return { nodes, links };
}