import { GridSkeleton } from "@/components/skeletons/CardSkeleton";

export default function Cargando() {
  return (
    <>
      <div className="border-b border-borde">
        <div className="contenedor space-y-4 py-12">
          <div className="h-10 w-56 animate-pulse rounded-lg bg-superficie-alta" />
          <div className="h-4 w-full max-w-2xl animate-pulse rounded bg-superficie-alta" />
          <div className="flex gap-6 pt-2">
            <div className="h-12 w-20 animate-pulse rounded bg-superficie-alta" />
            <div className="h-12 w-28 animate-pulse rounded bg-superficie-alta" />
          </div>
        </div>
      </div>
      <div className="contenedor py-10">
        <GridSkeleton cantidad={5} />
      </div>
    </>
  );
}
