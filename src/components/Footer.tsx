export function Footer() {
  return (
    <footer className="mt-16 border-t border-borde bg-superficie/40">
      <div className="contenedor flex flex-col gap-3 py-8 text-sm text-tenue sm:flex-row sm:items-center sm:justify-between">
        <p>
          <span className="font-semibold text-texto">AnimeVerse</span> — proyecto
          académico de Kodigo.
        </p>
        <p>
          Next.js 16 · App Router · Supabase · Tailwind CSS v4
        </p>
      </div>
      <div className="contenedor pb-8">
        <p className="text-xs text-tenue/70">
          Metadatos y portadas provenientes de MyAnimeList (API pública Jikan) y
          de AniList. Las sinopsis son redacciones propias. Uso exclusivamente
          educativo, sin fines comerciales.
        </p>
      </div>
    </footer>
  );
}
