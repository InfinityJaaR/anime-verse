"use client";

import { ErrorEstado } from "@/components/ErrorEstado";

export default function Error(props: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <ErrorEstado
      {...props}
      titulo="No pudimos cargar este género"
      descripcion="Hubo un problema al consultar los animes de este género. Intenta de nuevo o explora otros géneros."
    />
  );
}
