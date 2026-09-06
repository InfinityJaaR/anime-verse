import type { Metadata } from "next";
import { Inter, Space_Grotesk } from "next/font/google";

import { Footer } from "@/components/Footer";
import { Header } from "@/components/Header";

import "./globals.css";

const fuenteSans = Inter({
  subsets: ["latin"],
  variable: "--fuente-sans",
  display: "swap",
});

const fuenteDisplay = Space_Grotesk({
  subsets: ["latin"],
  variable: "--fuente-display",
  display: "swap",
});

export const metadata: Metadata = {
  title: {
    default: "AnimeVerse — Catálogo de anime",
    // Las páginas hijas solo definen su título; el sufijo se añade aquí.
    template: "%s · AnimeVerse",
  },
  description:
    "Catálogo de anime construido con Next.js 16 (App Router) y Supabase. Explora series por género, revisa fichas detalladas y descubre recomendaciones.",
  keywords: ["anime", "catálogo", "Next.js", "Supabase", "App Router"],
  authors: [{ name: "Javier Alfaro" }],
  openGraph: {
    type: "website",
    locale: "es_SV",
    siteName: "AnimeVerse",
    title: "AnimeVerse — Catálogo de anime",
    description:
      "Explora anime por género con fichas detalladas. Next.js 16 + Supabase.",
  },
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="es">
      <body className={`${fuenteSans.variable} ${fuenteDisplay.variable}`}>
        {/* Salto de navegación para usuarios de teclado y lectores de pantalla */}
        <a
          href="#contenido"
          className="sr-only focus:not-sr-only focus:fixed focus:left-4 focus:top-4 focus:z-[100] focus:rounded-lg focus:bg-acento focus:px-4 focus:py-2 focus:font-semibold focus:text-white"
        >
          Saltar al contenido
        </a>

        <div className="flex min-h-dvh flex-col">
          <Header />
          <main id="contenido" className="flex-1">
            {children}
          </main>
          <Footer />
        </div>
      </body>
    </html>
  );
}
