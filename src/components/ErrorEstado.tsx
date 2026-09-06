"use client";

import Link from "next/link";
import { useEffect } from "react";

/**
 * UI compartida por todos los `error.tsx`.
 *
 * Nota sobre producción: Next.js oculta el mensaje real de los errores
 * lanzados en el servidor y lo sustituye por un `digest`, para no filtrar
 * detalles de la infraestructura. Por eso se muestra el mensaje cuando existe
 * (desarrollo) y el digest cuando no (producción), que es lo que permite
 * localizar el error en los logs del servidor.
 */
export function ErrorEstado({
  error,
  reset,
  titulo = "Algo salió mal",
  descripcion = "No pudimos cargar esta sección. Puede ser un problema temporal de conexión con la base de datos.",
}: {
  error: Error & { digest?: string };
  reset: () => void;
  titulo?: string;
  descripcion?: string;
}) {
  useEffect(() => {
    // En una app real esto iría a un servicio de observabilidad.
    console.error("[AnimeVerse]", error);
  }, [error]);

  return (
    <div className="contenedor flex min-h-[60vh] items-center justify-center py-16">
      <div className="w-full max-w-lg space-y-5 rounded-2xl border border-red-500/30 bg-red-500/5 p-8 text-center">
        <p aria-hidden="true" className="text-4xl">
          ⚠️
        </p>

        <div className="space-y-2">
          <h1 className="font-display text-2xl font-bold">{titulo}</h1>
          <p className="text-sm leading-relaxed text-tenue">{descripcion}</p>
        </div>

        {(error.message || error.digest) && (
          <pre className="overflow-x-auto whitespace-pre-wrap rounded-lg border border-borde bg-superficie p-3 text-left text-xs text-tenue">
            {error.message || `Referencia del error: ${error.digest}`}
          </pre>
        )}

        <div className="flex flex-wrap justify-center gap-3">
          <button
            type="button"
            onClick={reset}
            className="rounded-lg bg-acento px-5 py-2.5 text-sm font-semibold text-white transition-colors hover:bg-acento-suave"
          >
            Reintentar
          </button>
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
