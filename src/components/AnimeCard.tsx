import Link from "next/link";

import { PosterImage } from "@/components/PosterImage";
import type { AnimeConGenero } from "@/types/database";

/**
 * Tarjeta de anime del grid. Server Component: no necesita interactividad
 * propia más allá del enlace y los estados de hover, que son puro CSS.
 */
export function AnimeCard({
  anime,
  prioridad = false,
  mostrarGenero = true,
}: {
  anime: AnimeConGenero;
  /** `true` para las primeras tarjetas visibles (LCP). */
  prioridad?: boolean;
  mostrarGenero?: boolean;
}) {
  return (
    <Link
      href={`/animes/${anime.slug}`}
      className="group block h-full focus-visible:outline-none"
    >
      <article className="flex h-full flex-col overflow-hidden rounded-xl border border-borde bg-superficie transition duration-300 ease-[var(--ease-suave)] group-hover:-translate-y-1 group-hover:border-acento/60 group-hover:shadow-[0_1rem_2.5rem_-1rem_rgba(168,85,247,0.45)] group-focus-visible:border-acento">
        <div className="relative aspect-[2/3] overflow-hidden bg-superficie-alta">
          <PosterImage
            src={anime.imagen_url}
            alt={anime.titulo}
            color={anime.genero.color}
            priority={prioridad}
            sizes="(max-width: 640px) 50vw, (max-width: 1024px) 33vw, 20vw"
            className="transition duration-500 ease-[var(--ease-suave)] group-hover:scale-105"
          />

          {/* Degradado inferior para que la puntuación siempre se lea */}
          <div className="pointer-events-none absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent" />

          <span className="absolute right-2 top-2 rounded-md bg-black/70 px-2 py-1 text-xs font-semibold text-white backdrop-blur-sm">
            ★ {anime.puntuacion.toFixed(1)}
          </span>

          {mostrarGenero && (
            <span
              className="absolute bottom-2 left-2 rounded-md px-2 py-0.5 text-[0.7rem] font-semibold text-white"
              style={{ backgroundColor: anime.genero.color }}
            >
              {anime.genero.nombre}
            </span>
          )}
        </div>

        <div className="flex flex-1 flex-col gap-1 p-3">
          <h3 className="line-clamp-2 text-sm font-semibold leading-snug transition-colors group-hover:text-acento-suave">
            {anime.titulo}
          </h3>
          <p className="text-xs text-tenue">
            {anime.anio} · {anime.episodios} ep
          </p>
        </div>
      </article>
    </Link>
  );
}
