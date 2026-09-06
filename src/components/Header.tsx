import Link from "next/link";

const ENLACES = [
  { href: "/animes", texto: "Catálogo" },
  { href: "/generos", texto: "Géneros" },
] as const;

export function Header() {
  return (
    <header className="sticky top-0 z-50 border-b border-borde/80 bg-fondo/80 backdrop-blur-md">
      <div className="contenedor flex h-16 items-center justify-between gap-4">
        <Link
          href="/"
          className="font-display text-lg font-bold tracking-tight transition-colors hover:text-acento-suave"
        >
          Anime<span className="text-acento">Verse</span>
        </Link>

        <nav aria-label="Navegación principal">
          <ul className="flex items-center gap-1 sm:gap-2">
            {ENLACES.map((enlace) => (
              <li key={enlace.href}>
                <Link
                  href={enlace.href}
                  className="rounded-lg px-3 py-2 text-sm font-medium text-tenue transition-colors hover:bg-superficie-alta hover:text-texto"
                >
                  {enlace.texto}
                </Link>
              </li>
            ))}
          </ul>
        </nav>
      </div>
    </header>
  );
}
