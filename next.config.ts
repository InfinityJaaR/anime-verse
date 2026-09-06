import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  images: {
    /**
     * Las portadas se sirven desde el CDN público de MyAnimeList.
     * Next.js exige declarar explícitamente los hosts remotos permitidos
     * (`images.domains` quedó obsoleto en Next.js 16).
     */
    remotePatterns: [
      {
        protocol: "https",
        hostname: "cdn.myanimelist.net",
        pathname: "/images/anime/**",
      },
    ],
  },
};

export default nextConfig;
