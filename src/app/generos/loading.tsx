import { TituloSkeleton } from "@/components/skeletons/CardSkeleton";

export default function Cargando() {
  return (
    <div className="contenedor space-y-8 py-12">
      <TituloSkeleton ancho="18rem" />
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {Array.from({ length: 6 }, (_, i) => (
          <div
            key={i}
            className="h-36 animate-pulse rounded-xl border border-borde bg-superficie-alta"
          />
        ))}
      </div>
    </div>
  );
}
