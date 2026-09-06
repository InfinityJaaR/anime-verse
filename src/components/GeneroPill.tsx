import Link from "next/link";

import type { GeneroResumen } from "@/types/database";

/** Enlace-píldora que lleva de un anime a la página de su género. */
export function GeneroPill({
  genero,
  total,
}: {
  genero: GeneroResumen;
  /** Si se indica, muestra el número de animes del género. */
  total?: number;
}) {
  return (
    <Link
      href={`/generos/${genero.slug}`}
      className="inline-flex items-center gap-2 rounded-full border px-3.5 py-1.5 text-sm font-medium transition duration-200 hover:-translate-y-0.5"
      style={{
        borderColor: `color-mix(in oklab, ${genero.color} 55%, transparent)`,
        backgroundColor: `color-mix(in oklab, ${genero.color} 14%, transparent)`,
        color: genero.color,
      }}
    >
      <span
        aria-hidden="true"
        className="size-2 rounded-full"
        style={{ backgroundColor: genero.color }}
      />
      {genero.nombre}
      {total !== undefined && (
        <span className="text-xs text-tenue">({total})</span>
      )}
    </Link>
  );
}
