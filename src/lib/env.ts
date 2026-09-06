/**
 * Lectura y validación de las variables de entorno de Supabase.
 *
 * Sin esta validación, una variable ausente produce el error críptico
 * "supabaseUrl is required" en tiempo de ejecución. Aquí se falla temprano
 * y con un mensaje que dice exactamente qué hacer.
 */

function leerVariable(nombre: string, valor: string | undefined): string {
  if (!valor || valor.trim() === "") {
    throw new Error(
      `Falta la variable de entorno ${nombre}. ` +
        `Copia .env.example a .env.local y completa los valores de tu proyecto de Supabase ` +
        `(Dashboard > Project Settings > API).`,
    );
  }
  return valor.trim();
}

// Estas referencias deben escribirse completas y literales: Next.js sustituye
// `process.env.NEXT_PUBLIC_*` en tiempo de compilación mediante análisis
// estático, por lo que un acceso dinámico como process.env[nombre] no funciona.
export const SUPABASE_URL = leerVariable(
  "NEXT_PUBLIC_SUPABASE_URL",
  process.env.NEXT_PUBLIC_SUPABASE_URL,
);

export const SUPABASE_ANON_KEY = leerVariable(
  "NEXT_PUBLIC_SUPABASE_ANON_KEY",
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
);
