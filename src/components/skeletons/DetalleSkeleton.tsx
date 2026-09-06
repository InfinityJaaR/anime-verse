/** Esqueleto de la ficha de detalle de un anime (/animes/[slug]). */
export function DetalleSkeleton() {
  return (
    <div className="contenedor py-10">
      <div className="grid gap-8 md:grid-cols-[minmax(0,18rem)_1fr]">
        {/* Portada */}
        <div className="aspect-[2/3] w-full animate-pulse rounded-2xl bg-superficie-alta" />

        {/* Ficha */}
        <div className="space-y-6">
          <div className="space-y-3">
            <div className="h-10 w-3/4 animate-pulse rounded-lg bg-superficie-alta" />
            <div className="h-5 w-1/3 animate-pulse rounded bg-superficie-alta" />
          </div>

          <div className="flex gap-2">
            <div className="h-7 w-28 animate-pulse rounded-full bg-superficie-alta" />
            <div className="h-7 w-24 animate-pulse rounded-full bg-superficie-alta" />
          </div>

          <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
            {Array.from({ length: 4 }, (_, i) => (
              <div
                key={i}
                className="h-20 animate-pulse rounded-xl bg-superficie-alta"
              />
            ))}
          </div>

          <div className="space-y-2">
            {Array.from({ length: 4 }, (_, i) => (
              <div
                key={i}
                className="h-4 animate-pulse rounded bg-superficie-alta"
                style={{ width: i === 3 ? "60%" : "100%" }}
              />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
