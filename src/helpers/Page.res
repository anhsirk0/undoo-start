include Site

module Page = {
  type t = {
    id: int,
    title: string,
    icon: string,
    sites: array<Site.t>,
  }

  let defaultPages: array<t> = [
    {
      id: 0,
      title: "Home",
      icon: `🏠`,
      sites: Site.defaultSites,
    },
    {
      id: 1,
      title: "Second",
      icon: `🏛`,
      sites: Array.slice(Site.defaultSites, ~start=0, ~end=1),
    },
  ]
}
