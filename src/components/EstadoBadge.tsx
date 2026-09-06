import type { EstadoAnime } from "@/types/database";

const ESTILOS: Record<EstadoAnime, string> = {
  "En emisión": "border-emerald-500/40 bg-emerald-500/10 text-emerald-300",
  Finalizado: "border-sky-500/40 bg-sky-500/10 text-sky-300",
  Próximamente: "border-amber-500/40 bg-amber-500/10 text-amber-300",
};

export function EstadoBadge({ estado }: { estado: EstadoAnime }) {
  return (
    <span
      className={`inline-flex items-center rounded-full border px-3 py-1 text-xs font-semibold ${
        ESTILOS[estado] ?? ESTILOS.Finalizado
      }`}
    >
      {estado}
    </span>
  );
}
