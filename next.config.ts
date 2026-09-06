import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  images: {
    /**
     * Las portadas se sirven desde los CDN públicos de MyAnimeList y AniList.
     * Next.js exige declarar explícitamente los hosts remotos permitidos
     * (`images.domains` quedó obsoleto en Next.js 16).
     */
    remotePatterns: [
      {
        protocol: "https",
        hostname: "cdn.myanimelist.net",
        pathname: "/images/anime/**",
      },
      {
        protocol: "https",
        hostname: "s4.anilist.co",
        pathname: "/file/anilistcdn/media/anime/**",
      },
    ],
  },
};

export default nextConfig;
