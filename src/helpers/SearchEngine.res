module SearchEngine = {
  type t = {
    id: int,
    title: string,
    url: string,
    icon: string,
  }

  let defaultEngines: array<t> = [
    {
      id: 0,
      title: "Duckduckgo",
      url: "https://duckduckgo.com/?q=<Q>",
      icon: `🦆`,
    },
    {
      id: 1,
      title: "Startpage",
      url: "https://www.startpage.com/sp/search?query=<Q>",
      icon: `🪿`,
    },
    {
      id: 2,
      title: "Google",
      url: "https://www.google.com/search?q=<Q>",
      icon: `G`,
    },
  ]
}
