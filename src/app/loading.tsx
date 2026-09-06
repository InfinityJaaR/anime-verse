import { GridSkeleton, TituloSkeleton } from "@/components/skeletons/CardSkeleton";

/** Estado de carga de la landing mientras se resuelven las consultas. */
export default function Cargando() {
  return (
    <div className="contenedor space-y-12 py-14">
      <TituloSkeleton ancho="36rem" />
      <GridSkeleton cantidad={5} />
    </div>
  );
}
