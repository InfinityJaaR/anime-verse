import { AnimeCard } from "@/components/AnimeCard";
import type { AnimeConGenero } from "@/types/database";

/** Grid responsive de tarjetas: 2 columnas en móvil hasta 5 en escritorio. */
export function AnimeGrid({
  animes,
  mostrarGenero = true,
  mensajeVacio = "No hay animes para mostrar todavía.",
}: {
  animes: AnimeConGenero[];
  mostrarGenero?: boolean;
  mensajeVacio?: string;
}) {
  if (animes.length === 0) {
    return (
      <p className="rounded-xl border border-dashed border-borde bg-superficie/60 p-8 text-center text-sm text-tenue">
        {mensajeVacio}
      </p>
    );
  }

  return (
    <div className="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5">
      {animes.map((anime, indice) => (
        <AnimeCard
          key={anime.id}
          anime={anime}
          mostrarGenero={mostrarGenero}
          prioridad={indice < 5}
        />
      ))}
    </div>
  );
}
