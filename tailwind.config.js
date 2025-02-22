import { screens, themes } from "./src/Config.res.mjs";
import daisyui from "daisyui";

/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.res.mjs"],
  theme: {
    extend: {},
    screens,
    keyframes: {
      shake: {
        "25%": { transform: "rotate(-4deg)" },
        "75%": { transform: "rotate(4deg)" },
        "100%": { transform: "rotate(0)" },
      },
      grow: {
        "0%": { transform: "scale(0)" },
        "100%": { transform: "scale(1)" },
      },
      fade: {
        "0%": { opacity: 0 },
        "100%": { opacity: 1 },
      },
    },
    animation: {
      shake: "shake 200ms ease-in-out infinite",
      grow: "grow 400ms ease-in-out",
      fade: "fade 400ms ease-in-out",
    },
  },
  plugins: [daisyui],
  daisyui: { themes, darkTheme: "dark" },
};
