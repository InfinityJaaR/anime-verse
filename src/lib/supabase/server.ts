import "server-only";

import { createClient } from "@supabase/supabase-js";

import { SUPABASE_ANON_KEY, SUPABASE_URL } from "@/lib/env";

/**
 * Cliente de Supabase para Server Components.
 *
 * ¿Por qué `@supabase/supabase-js` y no `@supabase/ssr`?
 * `@supabase/ssr` existe para sincronizar la sesión del usuario a través de
 * cookies. Esta aplicación no tiene autenticación: todas las lecturas son
 * públicas y anónimas. Usar el cliente normal evita tocar cookies y, por
 * tanto, permite que Next.js prerenderice las páginas de forma estática
 * (`generateStaticParams`) en lugar de forzarlas a renderizado dinámico.
 *
 * El import `server-only` garantiza en tiempo de compilación que este módulo
 * nunca termine dentro del bundle del navegador.
 */
export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
  auth: {
    // No hay login: no hace falta persistir ni refrescar sesiones.
    persistSession: false,
    autoRefreshToken: false,
  },
});
