-- ============================================================================
--  AnimeVerse — Esquema de base de datos
--  Ejecutar en Supabase: Dashboard > SQL Editor > New query > pegar > Run
--
--  Este script es idempotente: se puede volver a ejecutar sin errores.
--  Crea las tablas `generos` y `animes`, sus indices y las politicas RLS
--  que permiten SOLO lectura publica anonima.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. Limpieza previa (permite re-ejecutar el script desde cero)
-- ---------------------------------------------------------------------------
drop table if exists public.animes cascade;
drop table if exists public.generos cascade;

-- ---------------------------------------------------------------------------
-- 2. Tabla `generos`
--    Alimenta la ruta dinamica /generos/[slug]
-- ---------------------------------------------------------------------------
create table public.generos (
  id          bigint generated always as identity primary key,
  slug        text        not null unique,
  nombre      text        not null,
  descripcion text        not null,
  color       text        not null default '#8b5cf6',
  created_at  timestamptz not null default now(),

  constraint generos_slug_formato check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  constraint generos_color_hex     check (color ~ '^#[0-9a-fA-F]{6}$')
);

comment on table  public.generos is 'Generos de anime. Cada uno tiene su propia pagina en /generos/[slug].';
comment on column public.generos.slug  is 'Identificador legible usado en la URL.';
comment on column public.generos.color is 'Color hex de acento para la UI del genero.';

-- ---------------------------------------------------------------------------
-- 3. Tabla `animes`
--    Alimenta la ruta dinamica /animes/[slug]
--    Relacion 1:N -> un genero tiene muchos animes
-- ---------------------------------------------------------------------------
create table public.animes (
  id             bigint generated always as identity primary key,
  slug           text        not null unique,
  titulo         text        not null,
  titulo_japones text,
  sinopsis       text        not null,
  imagen_url     text        not null,
  anio           smallint    not null,
  episodios      smallint    not null,
  estado         text        not null default 'Finalizado',
  estudio        text        not null,
  puntuacion     numeric(3,1) not null,
  destacado      boolean     not null default false,
  tags           text[]      not null default '{}',
  genero_id      bigint      not null references public.generos (id) on delete restrict,
  created_at     timestamptz not null default now(),

  constraint animes_slug_formato  check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  constraint animes_estado_valido check (estado in ('En emisión', 'Finalizado', 'Próximamente')),
  constraint animes_anio_valido   check (anio between 1960 and 2100),
  constraint animes_puntuacion    check (puntuacion between 0 and 10),
  constraint animes_episodios     check (episodios > 0)
);

comment on table  public.animes is 'Catalogo de animes. Cada uno tiene su propia pagina en /animes/[slug].';
comment on column public.animes.destacado is 'Si es true aparece en la seccion destacada de la landing.';
comment on column public.animes.genero_id is 'Genero principal (FK -> generos.id).';

-- ---------------------------------------------------------------------------
-- 4. Indices
--    Aceleran las consultas que realmente hace la app
-- ---------------------------------------------------------------------------
create index animes_genero_id_idx  on public.animes (genero_id);
create index animes_destacado_idx  on public.animes (destacado) where destacado;
create index animes_puntuacion_idx on public.animes (puntuacion desc);

-- ---------------------------------------------------------------------------
-- 5. Row Level Security (RLS)
--
--    Se habilita RLS en ambas tablas y se crea UNICAMENTE una politica de
--    SELECT para los roles `anon` (visitantes sin sesion) y `authenticated`.
--
--    Al no existir politicas de INSERT / UPDATE / DELETE, cualquier intento
--    de escritura con la clave publica (anon key) es rechazado por Postgres.
--    Es decir: la base es de solo lectura para el frontend.
-- ---------------------------------------------------------------------------
alter table public.generos enable row level security;
alter table public.animes  enable row level security;

drop policy if exists "Lectura publica de generos" on public.generos;
create policy "Lectura publica de generos"
  on public.generos
  for select
  to anon, authenticated
  using (true);

drop policy if exists "Lectura publica de animes" on public.animes;
create policy "Lectura publica de animes"
  on public.animes
  for select
  to anon, authenticated
  using (true);

-- ---------------------------------------------------------------------------
-- 6. Comprobacion rapida
-- ---------------------------------------------------------------------------
select
  tablename,
  rowsecurity as rls_habilitado,
  (select count(*) from pg_policies p
    where p.schemaname = t.schemaname and p.tablename = t.tablename) as politicas
from pg_tables t
where schemaname = 'public' and tablename in ('animes', 'generos');
