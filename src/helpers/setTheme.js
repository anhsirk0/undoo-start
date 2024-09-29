function setTheme(theme) {
  const html = document.querySelector("html");
  if (html) html.setAttribute("data-theme", theme);
}

export default setTheme;
