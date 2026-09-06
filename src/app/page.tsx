import Link from "next/link";

import { AnimeGrid } from "@/components/AnimeGrid";
import { PosterImage } from "@/components/PosterImage";
import { getAnimesDestacados, getGeneros } from "@/lib/queries";

/**
 * Landing page. Server Component puro: los datos se leen de Supabase durante
 * el renderizado en el servidor, así que el HTML llega al navegador ya
 * completo (sin spinners ni fetch en el cliente).
 *
 * Se revalida cada hora (ISR): la página se sirve estática y se regenera en
 * segundo plano cuando caduca.
 */
export const revalidate = 3600;

export default async function PaginaInicio() {
  // Las dos consultas son independientes: se lanzan en paralelo en lugar de
  // encadenar dos await y pagar la latencia dos veces.
  const [destacados, generos] = await Promise.all([
    getAnimesDestacados(5),
    getGeneros(),
  ]);

  const principal = destacados[0];
  const resto = destacados.slice(1);

  return (
    <>
      {/* ---------------------------------------------------------------- */}
      {/* Hero                                                             */}
      {/* ---------------------------------------------------------------- */}
      <section className="contenedor pb-16 pt-14 sm:pt-20">
        <div className="grid items-center gap-10 lg:grid-cols-[1.15fr_minmax(0,20rem)]">
          <div className="aparecer space-y-6">
            <p className="inline-flex items-center gap-2 rounded-full border border-acento/40 bg-acento/10 px-3.5 py-1.5 text-xs font-semibold uppercase tracking-wider text-acento-suave">
              Next.js 16 · App Router · Supabase
            </p>

            <h1 className="font-display text-4xl font-bold leading-[1.1] sm:text-5xl lg:text-6xl">
              El anime que vale la pena,{" "}
              <span className="text-acento">ordenado por género</span>
            </h1>

            <p className="max-w-xl text-base leading-relaxed text-tenue sm:text-lg">
              Un catálogo curado de series imprescindibles con fichas
              detalladas: estudio, año, episodios y puntuación. Todo servido
              desde una base de datos serverless y renderizado en el servidor.
            </p>

            <div className="flex flex-wrap gap-3">
              <Link
                href="/animes"
                className="rounded-lg bg-acento px-5 py-2.5 text-sm font-semibold text-white transition duration-200 hover:bg-acento-suave hover:shadow-[0_0.75rem_2rem_-0.75rem_rgba(168,85,247,0.7)]"
              >
                Ver el catálogo
              </Link>
              <Link
                href="#generos"
                className="rounded-lg border border-borde bg-superficie px-5 py-2.5 text-sm font-semibold transition duration-200 hover:border-acento/60 hover:bg-superficie-alta"
              >
                Explorar géneros
              </Link>
            </div>
          </div>

          {/* Portada del mejor puntuado, como pieza visual del hero */}
          {principal && (
            <Link
              href={`/animes/${principal.slug}`}
              className="group relative mx-auto hidden aspect-[2/3] w-full max-w-xs overflow-hidden rounded-2xl border border-borde shadow-2xl lg:block"
            >
              <PosterImage
                src={principal.imagen_url}
                alt={principal.titulo}
                color={principal.genero.color}
                priority
                sizes="20rem"
                className="transition duration-700 ease-[var(--ease-suave)] group-hover:scale-105"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/20 to-transparent" />
              <div className="absolute inset-x-0 bottom-0 space-y-1 p-5">
                <p className="text-xs font-semibold uppercase tracking-wider text-acento-suave">
                  Mejor puntuado
                </p>
                <p className="font-display text-lg font-bold leading-tight">
                  {principal.titulo}
                </p>
                <p className="text-sm text-tenue">
                  ★ {principal.puntuacion.toFixed(1)} · {principal.estudio}
                </p>
              </div>
            </Link>
          )}
        </div>
      </section>

      {/* ---------------------------------------------------------------- */}
      {/* Destacados                                                       */}
      {/* ---------------------------------------------------------------- */}
      <section className="contenedor py-4">
        <EncabezadoSeccion
          titulo="Destacados"
          descripcion="Las series que mejor representan lo que puede hacer el medio."
          enlace={{ href: "/animes", texto: "Ver todo" }}
        />
        <AnimeGrid animes={resto.length > 0 ? resto : destacados} />
      </section>

      {/* ---------------------------------------------------------------- */}
      {/* Géneros                                                          */}
      {/* ---------------------------------------------------------------- */}
      <section id="generos" className="contenedor scroll-mt-24 pb-8 pt-16">
        <EncabezadoSeccion
          titulo="Géneros"
          descripcion="Cada género tiene su propia página generada dinámicamente."
          enlace={{ href: "/generos", texto: "Ver todos" }}
        />

        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {generos.map((genero) => (
            <Link
              key={genero.id}
              href={`/generos/${genero.slug}`}
              className="group relative overflow-hidden rounded-xl border border-borde bg-superficie p-5 transition duration-300 ease-[var(--ease-suave)] hover:-translate-y-1 hover:border-transparent"
              style={{ ["--acento-genero" as string]: genero.color }}
            >
              {/* Velo de color que aparece al pasar el cursor */}
              <span
                aria-hidden="true"
                className="pointer-events-none absolute inset-0 opacity-0 transition-opacity duration-300 group-hover:opacity-100"
                style={{
                  background: `linear-gradient(135deg, color-mix(in oklab, ${genero.color} 22%, transparent), transparent 65%)`,
                }}
              />
              <div className="relative space-y-2">
                <div className="flex items-center justify-between gap-3">
                  <h3
                    className="font-display text-lg font-bold"
                    style={{ color: genero.color }}
                  >
                    {genero.nombre}
                  </h3>
                  <span className="shrink-0 rounded-md bg-superficie-alta px-2 py-1 text-xs font-semibold text-tenue">
                    {genero.total_animes}{" "}
                    {genero.total_animes === 1 ? "serie" : "series"}
                  </span>
                </div>
                <p className="line-clamp-3 text-sm leading-relaxed text-tenue">
                  {genero.descripcion}
                </p>
              </div>
            </Link>
          ))}
        </div>
      </section>
    </>
  );
}

/** Cabecera compartida por las secciones de la landing. */
function EncabezadoSeccion({
  titulo,
  descripcion,
  enlace,
}: {
  titulo: string;
  descripcion: string;
  enlace?: { href: string; texto: string };
}) {
  return (
    <div className="mb-6 flex flex-wrap items-end justify-between gap-3">
      <div className="space-y-1">
        <h2 className="font-display text-2xl font-bold sm:text-3xl">{titulo}</h2>
        <p className="text-sm text-tenue">{descripcion}</p>
      </div>
      {enlace && (
        <Link
          href={enlace.href}
          className="text-sm font-semibold text-acento-suave transition-colors hover:text-acento"
        >
          {enlace.texto} →
        </Link>
      )}
    </div>
  );
}
