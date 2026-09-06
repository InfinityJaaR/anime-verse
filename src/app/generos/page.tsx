import type { Metadata } from "next";
import Link from "next/link";

import { getGeneros } from "@/lib/queries";

export const revalidate = 3600;

export const metadata: Metadata = {
  title: "Géneros",
  description:
    "Todos los géneros del catálogo de AnimeVerse con el número de series de cada uno.",
};

export default async function PaginaGeneros() {
  const generos = await getGeneros();

  return (
    <section className="contenedor py-12">
      <header className="mb-8 space-y-2">
        <h1 className="font-display text-3xl font-bold sm:text-4xl">Géneros</h1>
        <p className="text-tenue">
          Cada género abre su propia página en <code>/generos/[slug]</code>.
        </p>
      </header>

      <ul className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {generos.map((genero) => (
          <li key={genero.id}>
            <Link
              href={`/generos/${genero.slug}`}
              className="group relative flex h-full flex-col gap-2 overflow-hidden rounded-xl border border-borde bg-superficie p-5 transition duration-300 ease-[var(--ease-suave)] hover:-translate-y-1 hover:border-transparent"
            >
              <span
                aria-hidden="true"
                className="pointer-events-none absolute inset-0 opacity-0 transition-opacity duration-300 group-hover:opacity-100"
                style={{
                  background: `linear-gradient(135deg, color-mix(in oklab, ${genero.color} 22%, transparent), transparent 65%)`,
                }}
              />
              <div className="relative flex items-center justify-between gap-3">
                <h2
                  className="font-display text-lg font-bold"
                  style={{ color: genero.color }}
                >
                  {genero.nombre}
                </h2>
                <span className="shrink-0 rounded-md bg-superficie-alta px-2 py-1 text-xs font-semibold text-tenue">
                  {genero.total_animes}{" "}
                  {genero.total_animes === 1 ? "serie" : "series"}
                </span>
              </div>
              <p className="relative text-sm leading-relaxed text-tenue">
                {genero.descripcion}
              </p>
            </Link>
          </li>
        ))}
      </ul>
    </section>
  );
}
