import { GridSkeleton, TituloSkeleton } from "@/components/skeletons/CardSkeleton";

export default function Cargando() {
  return (
    <div className="contenedor space-y-8 py-12">
      <TituloSkeleton ancho="20rem" />
      <GridSkeleton cantidad={10} />
    </div>
  );
}
