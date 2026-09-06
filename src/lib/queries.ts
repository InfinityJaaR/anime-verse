import "server-only";

import type { PostgrestError } from "@supabase/supabase-js";

import { supabase } from "@/lib/supabase/server";
import type {
  Anime,
  AnimeConGenero,
  Genero,
  GeneroConConteo,
} from "@/types/database";

/**
 * Consultas de lectura contra Supabase.
 *
 * Todas se ejecutan exclusivamente en Server Components. Cuando Supabase
 * devuelve un error se lanza una excepción con un mensaje legible, de modo
 * que el `error.tsx` del segmento correspondiente tenga algo que mostrar en
 * lugar de un fallo silencioso o una pantalla en blanco.
 */
function fallar(contexto: string, error: PostgrestError): never {
  throw new Error(`No se pudo ${contexto}: ${error.message}`);
}

/** Columnas del anime + su género embebido mediante el join de PostgREST. */
const CAMPOS_CON_GENERO = "*, genero:generos(slug, nombre, color)";

// ---------------------------------------------------------------------------
// Animes
// ---------------------------------------------------------------------------

/** Animes marcados como destacados, para el bloque principal de la landing. */
export async function getAnimesDestacados(
  limite = 4,
): Promise<AnimeConGenero[]> {
  const { data, error } = await supabase
    .from("animes")
    .select(CAMPOS_CON_GENERO)
    .eq("destacado", true)
    .order("puntuacion", { ascending: false })
    .limit(limite)
    .returns<AnimeConGenero[]>();

  if (error) fallar("cargar los animes destacados", error);
  return data ?? [];
}

/** Catálogo completo, ordenado por puntuación descendente. */
export async function getAnimes(): Promise<AnimeConGenero[]> {
  const { data, error } = await supabase
    .from("animes")
    .select(CAMPOS_CON_GENERO)
    .order("puntuacion", { ascending: false })
    .returns<AnimeConGenero[]>();

  if (error) fallar("cargar el catálogo de animes", error);
  return data ?? [];
}

/**
 * Un anime por su slug. Devuelve `null` si no existe, para que la página
 * pueda responder con `notFound()` en lugar de reventar.
 */
export async function getAnimePorSlug(
  slug: string,
): Promise<AnimeConGenero | null> {
  const { data, error } = await supabase
    .from("animes")
    .select(CAMPOS_CON_GENERO)
    .eq("slug", slug)
    .maybeSingle<AnimeConGenero>();

  if (error) fallar(`cargar el anime "${slug}"`, error);
  return data;
}

/** Animes del mismo género, excluyendo el que se está viendo. */
export async function getAnimesRelacionados(
  generoId: number,
  slugExcluido: string,
  limite = 4,
): Promise<AnimeConGenero[]> {
  const { data, error } = await supabase
    .from("animes")
    .select(CAMPOS_CON_GENERO)
    .eq("genero_id", generoId)
    .neq("slug", slugExcluido)
    .order("puntuacion", { ascending: false })
    .limit(limite)
    .returns<AnimeConGenero[]>();

  if (error) fallar("cargar los animes relacionados", error);
  return data ?? [];
}

// ---------------------------------------------------------------------------
// Géneros
// ---------------------------------------------------------------------------

/** Todos los géneros con el número de animes que contiene cada uno. */
export async function getGeneros(): Promise<GeneroConConteo[]> {
  const { data, error } = await supabase
    .from("generos")
    .select("*, animes(count)")
    .order("nombre")
    .returns<(Genero & { animes: { count: number }[] })[]>();

  if (error) fallar("cargar los géneros", error);

  // PostgREST devuelve el agregado como `animes: [{ count: n }]`.
  return (data ?? []).map(({ animes, ...genero }) => ({
    ...genero,
    total_animes: animes[0]?.count ?? 0,
  }));
}

/** Un género por su slug, o `null` si no existe. */
export async function getGeneroPorSlug(slug: string): Promise<Genero | null> {
  const { data, error } = await supabase
    .from("generos")
    .select("*")
    .eq("slug", slug)
    .maybeSingle<Genero>();

  if (error) fallar(`cargar el género "${slug}"`, error);
  return data;
}

/** Animes que pertenecen a un género concreto. */
export async function getAnimesPorGenero(
  generoId: number,
): Promise<AnimeConGenero[]> {
  const { data, error } = await supabase
    .from("animes")
    .select(CAMPOS_CON_GENERO)
    .eq("genero_id", generoId)
    .order("puntuacion", { ascending: false })
    .returns<AnimeConGenero[]>();

  if (error) fallar("cargar los animes del género", error);
  return data ?? [];
}

// ---------------------------------------------------------------------------
// Slugs para `generateStaticParams` (prerenderizado de las rutas dinámicas)
// ---------------------------------------------------------------------------

export async function getSlugsAnimes(): Promise<Pick<Anime, "slug">[]> {
  const { data, error } = await supabase
    .from("animes")
    .select("slug")
    .returns<Pick<Anime, "slug">[]>();

  if (error) fallar("obtener los slugs de animes", error);
  return data ?? [];
}

export async function getSlugsGeneros(): Promise<Pick<Genero, "slug">[]> {
  const { data, error } = await supabase
    .from("generos")
    .select("slug")
    .returns<Pick<Genero, "slug">[]>();

  if (error) fallar("obtener los slugs de géneros", error);
  return data ?? [];
}
