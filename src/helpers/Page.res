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
      title: "Localhost",
      icon: `🏛`,
      sites: Site.localServers,
    },
  ]
}
