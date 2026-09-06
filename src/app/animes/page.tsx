import type { Metadata } from "next";

import { AnimeGrid } from "@/components/AnimeGrid";
import { getAnimes } from "@/lib/queries";

export const revalidate = 3600;

export const metadata: Metadata = {
  title: "Catálogo",
  description:
    "Todos los animes del catálogo de AnimeVerse, ordenados por puntuación.",
};

export default async function PaginaCatalogo() {
  const animes = await getAnimes();

  return (
    <section className="contenedor py-12">
      <header className="mb-8 space-y-2">
        <h1 className="font-display text-3xl font-bold sm:text-4xl">Catálogo</h1>
        <p className="text-tenue">
          {animes.length} series ordenadas por puntuación. Datos leídos desde
          Supabase en el servidor.
        </p>
      </header>

      <AnimeGrid animes={animes} />
    </section>
  );
}
