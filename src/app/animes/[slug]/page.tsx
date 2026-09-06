import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";

import { AnimeGrid } from "@/components/AnimeGrid";
import { EstadoBadge } from "@/components/EstadoBadge";
import { GeneroPill } from "@/components/GeneroPill";
import { PosterImage } from "@/components/PosterImage";
import {
  getAnimePorSlug,
  getAnimesRelacionados,
  getSlugsAnimes,
} from "@/lib/queries";

/**
 * ══ RUTA DINÁMICA 1 ══  /animes/[slug]
 *
 * Ficha de detalle de un anime. Todo se resuelve en el servidor.
 */

// ISR: la página se sirve estática y se regenera cada hora.
export const revalidate = 3600;

/**
 * `dynamicParams = false` hace que cualquier slug que no venga de
 * `generateStaticParams` devuelva un 404 real (con su código HTTP 404) en
 * lugar de intentar renderizarlo.
 *
 * El motivo es sutil: este segmento tiene un `loading.tsx`, lo que envuelve la
 * página en un Suspense y activa el streaming de la respuesta. Una vez que los
 * headers salieron —con status 200— `notFound()` ya no puede cambiarlos, así
 * que se obtendría un "soft 404": la página correcta pero con código 200.
 * Cerrando la lista de params en build, Next.js responde 404 antes de empezar
 * a renderizar.
 *
 * A cambio, un anime añadido a Supabase después del despliegue necesita un
 * nuevo build para ser accesible. Es el compromiso aceptable para un catálogo
 * curado; en un CMS con altas frecuentes se dejaría `dynamicParams` en `true`
 * y se asumiría el soft 404.
 */
export const dynamicParams = false;

/** Prerenderiza en build una página por cada anime de la base de datos. */
export async function generateStaticParams() {
  const animes = await getSlugsAnimes();
  return animes.map(({ slug }) => ({ slug }));
}

/** Metadatos por anime: título y descripción reales en la pestaña y al compartir. */
export async function generateMetadata({
  params,
}: PageProps<"/animes/[slug]">): Promise<Metadata> {
  // En Next.js 16 `params` es una Promise: el acceso síncrono fue eliminado.
  const { slug } = await params;
  const anime = await getAnimePorSlug(slug);

  if (!anime) {
    return { title: "Anime no encontrado" };
  }

  const descripcion = `${anime.titulo} (${anime.anio}) — ${anime.episodios} episodios, estudio ${anime.estudio}. Puntuación ${anime.puntuacion}/10.`;

  return {
    title: anime.titulo,
    description: descripcion,
    openGraph: {
      title: anime.titulo,
      description: descripcion,
      images: [{ url: anime.imagen_url, alt: anime.titulo }],
    },
  };
}

export default async function PaginaAnime({
  params,
}: PageProps<"/animes/[slug]">) {
  const { slug } = await params;
  const anime = await getAnimePorSlug(slug);

  // Slug inexistente -> 404 real (renderiza src/app/not-found.tsx).
  if (!anime) notFound();

  const relacionados = await getAnimesRelacionados(anime.genero_id, anime.slug);

  const ficha = [
    { etiqueta: "Año", valor: String(anime.anio) },
    { etiqueta: "Episodios", valor: String(anime.episodios) },
    { etiqueta: "Estudio", valor: anime.estudio },
    { etiqueta: "Puntuación", valor: `${anime.puntuacion.toFixed(1)} / 10` },
  ];

  return (
    <>
      {/* Banner: la portada difuminada de fondo da color a la cabecera */}
      <div className="relative">
        <div
          aria-hidden="true"
          className="absolute inset-x-0 top-0 -z-10 h-80"
          style={{
            background: `linear-gradient(180deg, color-mix(in oklab, ${anime.genero.color} 30%, transparent), transparent)`,
          }}
        />

        <article className="contenedor py-10">
          <nav aria-label="Ruta de navegación" className="mb-6 text-sm text-tenue">
            <ol className="flex flex-wrap items-center gap-2">
              <li>
                <Link href="/" className="transition-colors hover:text-texto">
                  Inicio
                </Link>
              </li>
              <li aria-hidden="true">/</li>
              <li>
                <Link
                  href="/animes"
                  className="transition-colors hover:text-texto"
                >
                  Catálogo
                </Link>
              </li>
              <li aria-hidden="true">/</li>
              <li className="text-texto" aria-current="page">
                {anime.titulo}
              </li>
            </ol>
          </nav>

          <div className="grid gap-8 md:grid-cols-[minmax(0,18rem)_1fr]">
            {/* Portada */}
            <div className="relative mx-auto aspect-[2/3] w-full max-w-[18rem] overflow-hidden rounded-2xl border border-borde shadow-2xl">
              <PosterImage
                src={anime.imagen_url}
                alt={`Portada de ${anime.titulo}`}
                color={anime.genero.color}
                priority
                sizes="(max-width: 768px) 70vw, 18rem"
              />
            </div>

            {/* Información */}
            <div className="space-y-7">
              <header className="space-y-2">
                <h1 className="font-display text-3xl font-bold sm:text-4xl">
                  {anime.titulo}
                </h1>
                {anime.titulo_japones && (
                  <p lang="ja" className="text-lg text-tenue">
                    {anime.titulo_japones}
                  </p>
                )}
              </header>

              <div className="flex flex-wrap items-center gap-3">
                <GeneroPill genero={anime.genero} />
                <EstadoBadge estado={anime.estado} />
              </div>

              {/* Ficha técnica */}
              <dl className="grid grid-cols-2 gap-3 sm:grid-cols-4">
                {ficha.map((dato) => (
                  <div
                    key={dato.etiqueta}
                    className="rounded-xl border border-borde bg-superficie p-4"
                  >
                    <dt className="text-xs uppercase tracking-wide text-tenue">
                      {dato.etiqueta}
                    </dt>
                    <dd className="mt-1 font-display text-lg font-bold">
                      {dato.valor}
                    </dd>
                  </div>
                ))}
              </dl>

              <section className="space-y-2">
                <h2 className="font-display text-xl font-bold">Sinopsis</h2>
                <p className="max-w-3xl leading-relaxed text-tenue">
                  {anime.sinopsis}
                </p>
              </section>

              {anime.tags.length > 0 && (
                <section className="space-y-2">
                  <h2 className="font-display text-xl font-bold">Temas</h2>
                  <ul className="flex flex-wrap gap-2">
                    {anime.tags.map((tag) => (
                      <li
                        key={tag}
                        className="rounded-md border border-borde bg-superficie px-2.5 py-1 text-xs font-medium text-tenue"
                      >
                        {tag}
                      </li>
                    ))}
                  </ul>
                </section>
              )}
            </div>
          </div>
        </article>
      </div>

      {/* Puente hacia la otra ruta dinámica: /generos/[slug] */}
      <section className="contenedor pb-16">
        <div className="mb-6 flex flex-wrap items-end justify-between gap-3">
          <div className="space-y-1">
            <h2 className="font-display text-2xl font-bold">
              Más de {anime.genero.nombre}
            </h2>
            <p className="text-sm text-tenue">
              Otras series del mismo género en el catálogo.
            </p>
          </div>
          <Link
            href={`/generos/${anime.genero.slug}`}
            className="text-sm font-semibold text-acento-suave transition-colors hover:text-acento"
          >
            Ver el género completo →
          </Link>
        </div>

        <AnimeGrid
          animes={relacionados}
          mostrarGenero={false}
          mensajeVacio={`De momento este es el único anime de ${anime.genero.nombre} en el catálogo.`}
        />
      </section>
    </>
  );
}
