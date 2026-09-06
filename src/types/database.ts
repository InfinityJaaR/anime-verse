/**
 * Tipos de dominio que reflejan el esquema definido en `supabase/schema.sql`.
 *
 * Se escriben a mano (en lugar de generarlos con la CLI de Supabase) para que
 * el proyecto se pueda clonar y compilar sin necesidad de credenciales.
 */

export type EstadoAnime = "En emisión" | "Finalizado" | "Próximamente";

/** Fila de la tabla `generos`. */
export interface Genero {
  id: number;
  slug: string;
  nombre: string;
  descripcion: string;
  /** Color hex de acento, p. ej. `#8b5cf6`. */
  color: string;
  created_at: string;
}

/** Fila de la tabla `animes`. */
export interface Anime {
  id: number;
  slug: string;
  titulo: string;
  titulo_japones: string | null;
  sinopsis: string;
  imagen_url: string;
  anio: number;
  episodios: number;
  estado: EstadoAnime;
  estudio: string;
  puntuacion: number;
  destacado: boolean;
  tags: string[];
  genero_id: number;
  created_at: string;
}

/** Subconjunto del género que se embebe al consultar animes. */
export type GeneroResumen = Pick<Genero, "slug" | "nombre" | "color">;

/** Anime con su género ya resuelto por el join de PostgREST. */
export type AnimeConGenero = Anime & { genero: GeneroResumen };

/** Género acompañado del número de animes que contiene. */
export type GeneroConConteo = Genero & { total_animes: number };
