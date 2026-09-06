"use client";

import { ErrorEstado } from "@/components/ErrorEstado";

export default function Error(props: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <ErrorEstado
      {...props}
      titulo="No pudimos cargar este anime"
      descripcion="Hubo un problema al consultar la ficha en la base de datos. Intenta de nuevo o vuelve al catálogo."
    />
  );
}
