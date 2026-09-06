import Link from "next/link";

/**
 * Página 404. La renderiza Next.js cuando una ruta no existe o cuando una
 * página llama a `notFound()` — que es lo que hacen ambas rutas dinámicas
 * si el slug pedido no está en la base de datos.
 */
export default function NoEncontrado() {
  return (
    <div className="contenedor flex min-h-[65vh] items-center justify-center py-16">
      <div className="w-full max-w-lg space-y-6 text-center">
        <p className="font-display text-7xl font-bold text-acento">404</p>

        <div className="space-y-2">
          <h1 className="font-display text-2xl font-bold">
            Esta página no existe
          </h1>
          <p className="text-sm leading-relaxed text-tenue">
            El anime o el género que buscas no está en el catálogo. Puede que el
            enlace esté mal escrito o que el registro ya no esté en la base de
            datos.
          </p>
        </div>

        <div className="flex flex-wrap justify-center gap-3">
          <Link
            href="/animes"
            className="rounded-lg bg-acento px-5 py-2.5 text-sm font-semibold text-white transition-colors hover:bg-acento-suave"
          >
            Ver el catálogo
          </Link>
          <Link
            href="/"
            className="rounded-lg border border-borde bg-superficie px-5 py-2.5 text-sm font-semibold transition-colors hover:bg-superficie-alta"
          >
            Volver al inicio
          </Link>
        </div>
      </div>
    </div>
  );
}
