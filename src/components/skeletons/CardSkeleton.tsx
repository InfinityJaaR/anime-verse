/**
 * Esqueletos de carga.
 *
 * Imitan la geometría real del contenido (proporción 2:3 de la portada, dos
 * líneas de título, una de metadatos) para que no haya salto de layout cuando
 * llegan los datos: la página no "brinca" al pasar del loading al contenido.
 */

export function CardSkeleton() {
  return (
    <div className="overflow-hidden rounded-xl border border-borde bg-superficie">
      <div className="aspect-[2/3] animate-pulse bg-superficie-alta" />
      <div className="space-y-2 p-3">
        <div className="h-3.5 w-full animate-pulse rounded bg-superficie-alta" />
        <div className="h-3.5 w-2/3 animate-pulse rounded bg-superficie-alta" />
        <div className="h-3 w-1/2 animate-pulse rounded bg-superficie-alta" />
      </div>
    </div>
  );
}

/** Grid de esqueletos con la misma disposición responsive que `AnimeGrid`. */
export function GridSkeleton({ cantidad = 10 }: { cantidad?: number }) {
  return (
    <div className="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5">
      {Array.from({ length: cantidad }, (_, i) => (
        <CardSkeleton key={i} />
      ))}
    </div>
  );
}

/** Bloque de texto genérico: una cabecera de sección. */
export function TituloSkeleton({ ancho = "16rem" }: { ancho?: string }) {
  return (
    <div className="space-y-3">
      <div
        className="h-9 animate-pulse rounded-lg bg-superficie-alta"
        style={{ maxWidth: ancho }}
      />
      <div className="h-4 w-full max-w-lg animate-pulse rounded bg-superficie-alta" />
    </div>
  );
}
