@module("./logos/youtube.jpg") external youtubeLogo: string = "default"
@module("./logos/lichess.png") external lichessLogo: string = "default"

module Site = {
  type t = {
    id: int,
    title: string,
    url: string,
    icon: string,
    showLabel: bool,
  }

  let defaultSites: array<t> = [
    {
      id: 0,
      title: "Lichess",
      url: "https://lichess.org",
      icon: lichessLogo,
      showLabel: false,
    },
    {
      id: 1,
      title: "Lichess",
      url: "https://lichess.org",
      icon: "https://repository-images.githubusercontent.com/127672405/07285800-15e5-11ea-9d25-3875007e9e97",
      showLabel: true,
    },
    {
      id: 2,
      title: "Lichess",
      url: "https://lichess.org",
      icon: "Lichess",
      showLabel: true,
    },
    {
      id: 3,
      title: "Youtube",
      url: "https://youtube.com",
      icon: youtubeLogo,
      showLabel: false,
    },
    {
      id: 4,
      title: "Youtube",
      url: "https://youtube.com",
      icon: youtubeLogo,
      showLabel: true,
    },
  ]
}
