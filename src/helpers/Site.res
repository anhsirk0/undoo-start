@module("../assets/youtube.svg") external youtubeLogo: string = "default"
@module("../assets/whatsapp.svg") external whatsappLogo: string = "default"
@module("../assets/github.svg") external githubLogo: string = "default"
@module("../assets/codeberg.svg") external codebergLogo: string = "default"
@module("../assets/netflix.svg") external netflixLogo: string = "default"
@module("../assets/lichess.svg") external lichessLogo: string = "default"
@module("../assets/reddit.svg") external redditLogo: string = "default"
@module("../assets/duolingo.svg") external duolingoLogo: string = "default"
@module("../assets/facebook.svg") external facebookLogo: string = "default"
@module("../assets/instagram.svg") external instagramLogo: string = "default"
@module("../assets/messenger.svg") external messengerLogo: string = "default"
@module("../assets/spotify.svg") external spotifyLogo: string = "default"

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
      title: "Youtube",
      url: "https://youtube.com",
      icon: youtubeLogo,
      showLabel: false,
    },
    {
      id: 11,
      title: "Codeberg",
      url: "https://codeberg.com",
      icon: codebergLogo,
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
      title: "Facebook",
      url: "https://facebook.com",
      icon: facebookLogo,
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
    {
      id: 10,
      title: "Spotify",
      url: "https://spotify.com",
      icon: spotifyLogo,
      showLabel: false,
    },
  ]
}
