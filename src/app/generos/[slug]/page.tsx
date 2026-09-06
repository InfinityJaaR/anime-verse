import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";

import { AnimeGrid } from "@/components/AnimeGrid";
import {
  getAnimesPorGenero,
  getGeneroPorSlug,
  getSlugsGeneros,
} from "@/lib/queries";

/**
 * ══ RUTA DINÁMICA 2 ══  /generos/[slug]
 *
 * Listado de los animes de un género. Hace dos lecturas encadenadas a
 * Supabase: primero el género (para resolver su id) y después sus animes.
 */

export const revalidate = 3600;

// Ver la explicación en /animes/[slug]/page.tsx: garantiza un 404 con su
// código HTTP real pese al streaming que introduce `loading.tsx`.
export const dynamicParams = false;

export async function generateStaticParams() {
  const generos = await getSlugsGeneros();
  return generos.map(({ slug }) => ({ slug }));
}

export async function generateMetadata({
  params,
}: PageProps<"/generos/[slug]">): Promise<Metadata> {
  const { slug } = await params;
  const genero = await getGeneroPorSlug(slug);

  if (!genero) {
    return { title: "Género no encontrado" };
  }

  return {
    title: `Anime de ${genero.nombre}`,
    description: genero.descripcion,
    openGraph: {
      title: `Anime de ${genero.nombre} · AnimeVerse`,
      description: genero.descripcion,
    },
  };
}

export default async function PaginaGenero({
  params,
}: PageProps<"/generos/[slug]">) {
  const { slug } = await params;
  const genero = await getGeneroPorSlug(slug);

  if (!genero) notFound();

  const animes = await getAnimesPorGenero(genero.id);

  const promedio =
    animes.length > 0
      ? animes.reduce((suma, a) => suma + a.puntuacion, 0) / animes.length
      : 0;

  return (
    <>
      {/* Cabecera teñida con el color del género */}
      <header
        className="border-b border-borde"
        style={{
          background: `linear-gradient(180deg, color-mix(in oklab, ${genero.color} 24%, transparent), transparent)`,
        }}
      >
        <div className="contenedor py-12">
          <nav aria-label="Ruta de navegación" className="mb-5 text-sm text-tenue">
            <ol className="flex flex-wrap items-center gap-2">
              <li>
                <Link href="/" className="transition-colors hover:text-texto">
                  Inicio
                </Link>
              </li>
              <li aria-hidden="true">/</li>
              <li>
                <Link
                  href="/generos"
                  className="transition-colors hover:text-texto"
                >
                  Géneros
                </Link>
              </li>
              <li aria-hidden="true">/</li>
              <li className="text-texto" aria-current="page">
                {genero.nombre}
              </li>
            </ol>
          </nav>

          <div className="flex items-center gap-3">
            <span
              aria-hidden="true"
              className="size-3 rounded-full"
              style={{ backgroundColor: genero.color }}
            />
            <h1 className="font-display text-3xl font-bold sm:text-4xl">
              {genero.nombre}
            </h1>
          </div>

          <p className="mt-3 max-w-2xl leading-relaxed text-tenue">
            {genero.descripcion}
          </p>

          <dl className="mt-6 flex flex-wrap gap-x-10 gap-y-4 text-sm">
            <div>
              <dt className="text-tenue">Series</dt>
              <dd className="font-display text-xl font-bold">
                {animes.length}
              </dd>
            </div>
            <div>
              <dt className="text-tenue">Puntuación media</dt>
              <dd className="font-display text-xl font-bold">
                {animes.length > 0 ? `★ ${promedio.toFixed(2)}` : "—"}
              </dd>
            </div>
          </dl>
        </div>
      </header>

      <section className="contenedor py-10">
        <AnimeGrid
          animes={animes}
          mostrarGenero={false}
          mensajeVacio={`Todavía no hay animes de ${genero.nombre} en el catálogo.`}
        />
      </section>
    </>
  );
}
