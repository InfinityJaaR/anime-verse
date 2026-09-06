"use client";

import Image from "next/image";
import { useState } from "react";

/**
 * Único Client Component de la app.
 *
 * Existe por una razón concreta: `next/image` no puede reaccionar a una imagen
 * rota desde el servidor. Las portadas vienen de un CDN externo, así que si
 * alguna falla (404, caída del CDN, bloqueo de red) se muestra un degradado
 * derivado del color del género con las iniciales del título, en lugar de un
 * hueco vacío. El resto de la aplicación son Server Components.
 */
export function PosterImage({
  src,
  alt,
  color,
  sizes,
  priority = false,
  className = "",
}: {
  src: string;
  alt: string;
  /** Color hex del género, usado para el degradado de reserva. */
  color: string;
  sizes: string;
  priority?: boolean;
  className?: string;
}) {
  const [fallo, setFallo] = useState(false);

  if (fallo) {
    return (
      <div
        aria-label={alt}
        role="img"
        className={`flex h-full w-full items-center justify-center ${className}`}
        style={{
          background: `linear-gradient(145deg, ${color} 0%, #08080c 85%)`,
        }}
      >
        <span className="font-display text-3xl font-bold text-white/80">
          {iniciales(alt)}
        </span>
      </div>
    );
  }

  return (
    <Image
      src={src}
      alt={alt}
      fill
      sizes={sizes}
      priority={priority}
      onError={() => setFallo(true)}
      className={`object-cover ${className}`}
    />
  );
}

/** "Cowboy Bebop" -> "CB". Máximo dos letras. */
function iniciales(titulo: string): string {
  return titulo
    .split(/\s+/)
    .filter((palabra) => /[a-záéíóúñ]/i.test(palabra[0] ?? ""))
    .slice(0, 2)
    .map((palabra) => palabra[0]!.toUpperCase())
    .join("");
}
