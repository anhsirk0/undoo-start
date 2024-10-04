import themes from "./src/themes";

/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.res.mjs"],
  theme: {
    extend: {},
    screens: {
      xs: "480px",
      sm: "640px",
      md: "768px",
      lg: "1024px",
      xl: "1380px",
      xxl: "1536px",
    },
    keyframes: {
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
      grow: "grow 400ms ease-in-out",
      fade: "fade 200ms ease-in-out",
    },
  },
  plugins: [require("daisyui")],
  daisyui: {
    themes,
    darkTheme: "dark", // name of one of the included themes for dark mode
    base: true, // applies background color and foreground color for root element by default
    styled: true, // include daisyUI colors and design decisions for all components
    utils: true, // adds responsive and modifier utility classes
    prefix: "", // prefix for daisyUI classnames (components, modifiers and responsive class names. Not colors)
    logs: true, // Shows info about daisyUI version and used config in the console when building your CSS
    themeRoot: ":root",
  },
};
