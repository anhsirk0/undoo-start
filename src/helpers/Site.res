@module("../assets/youtube.jpg") external youtubeLogo: string = "default"
@module("../assets/whatsapp.jpg") external whatsappLogo: string = "default"
@module("../assets/github.png") external githubLogo: string = "default"
@module("../assets/netflix.png") external netflixLogo: string = "default"
@module("../assets/lichess.png") external lichessLogo: string = "default"
@module("../assets/reddit.jpg") external redditLogo: string = "default"
@module("../assets/duolingo.jpg") external duolingoLogo: string = "default"
@module("../assets/fb.jpg") external fbLogo: string = "default"
@module("../assets/instagram.jpg") external instagramLogo: string = "default"
@module("../assets/messenger.jpg") external messengerLogo: string = "default"

module Site = {
  type t = {
    id: int,
    title: string,
    url: string,
    icon: string,
    showLabel: bool,
  }

  let startsWith = (str, terms) => Array.some(terms, s => String.startsWith(str, s))

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
      title: "Youtube",
      url: "https://youtube.com",
      icon: youtubeLogo,
      showLabel: false,
    },
    {
      id: 2,
      title: "Github",
      url: "https://github.com",
      icon: githubLogo,
      showLabel: false,
    },
    {
      id: 3,
      title: "Reddit",
      url: "https://reddit.com",
      icon: redditLogo,
      showLabel: false,
    },
    {
      id: 4,
      title: "Netflix",
      url: "https://netflix.com",
      icon: netflixLogo,
      showLabel: false,
    },
    {
      id: 5,
      title: "Duolingo",
      url: "https://duolingo.com",
      icon: duolingoLogo,
      showLabel: false,
    },
    {
      id: 6,
      title: "Fb",
      url: "https://fb.com",
      icon: fbLogo,
      showLabel: false,
    },
    {
      id: 7,
      title: "Instagram",
      url: "https://instagram.com",
      icon: instagramLogo,
      showLabel: false,
    },
    {
      id: 8,
      title: "Whatsapp",
      url: "https://web.whatsapp.com",
      icon: whatsappLogo,
      showLabel: false,
    },
    {
      id: 9,
      title: "Messenger",
      url: "https://messenger.com",
      icon: messengerLogo,
      showLabel: false,
    },
  ]
}
