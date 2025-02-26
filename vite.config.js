import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import { VitePWA } from "vite-plugin-pwa";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    react({ include: ["**/*.res.mjs"] }),
    VitePWA({
      registerType: "autoUpdate",
      manifest: {
        name: "Undoo Startpage",
        short_name: "Undoo",
        start_url: "/",
        display: "standalone",
        background_color: "#ffffff",
        theme_color: "#ffffff",
        scope: "/",
        icons: [{ src: "/undoo.svg", type: "image/svg+xml", sizes: "any" }],
      },
    }),
  ],
  build: {
    rollupOptions: {
      output: {
        assetFileNames: (assetInfo) => {
          return `assets/${assetInfo.name}`;
        },
      },
    },
  },
});
