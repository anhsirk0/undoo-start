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
@module("../assets/svelte.svg") external svelteLogo: string = "default"
@module("../assets/react.svg") external reactLogo: string = "default"
@module("../assets/vue.svg") external vueLogo: string = "default"
@module("../assets/angular.svg") external angularLogo: string = "default"
@module("../assets/django.svg") external djangoLogo: string = "default"
@module("../assets/gmail.svg") external gmailLogo: string = "default"
@module("../assets/drive.svg") external driveLogo: string = "default"
@module("../assets/yandex.svg") external yandexLogo: string = "default"
@module("../assets/yandex-mail.svg") external yandexMailLogo: string = "default"
@module("../assets/image.svg") external imageLogo: string = "default"
@module("../assets/link.svg") external linkLogo: string = "default"
@module("../assets/search.svg") external searchLogo: string = "default"
@module("../assets/globe-green.svg") external globeGreen: string = "default"
@module("../assets/globe-blue.svg") external globeBlue: string = "default"
@module("../assets/globe-red.svg") external globeRed: string = "default"
@module("../assets/globe-yellow.svg") external globeYellow: string = "default"
@module("../assets/globe-pink.svg") external globePink: string = "default"
@module("../assets/globe-purple.svg") external globePurple: string = "default"
@module("../assets/linkedin.svg") external linkedinLogo: string = "default"
@module("../assets/twitter.svg") external twitterLogo: string = "default"
@module("../assets/x.svg") external xLogo: string = "default"
@module("../assets/discord.svg") external discordLogo: string = "default"
@module("../assets/openai.svg") external openaiLogo: string = "default"
@module("../assets/9gag.svg") external nineGagLogo: string = "default"
@module("../assets/amazon.svg") external amazonLogo: string = "default"
@module("../assets/mangadex.svg") external mangadexLogo: string = "default"
@module("../assets/undoo-blue.svg") external undooBlue: string = "default"
@module("../assets/undoo-light.svg") external undooLight: string = "default"

module Site = {
  type t = {
    id: float,
    title: string,
    url: string,
    icon: string,
    showLabel: bool,
    bgcolor?: string,
  }

  let empty = {
    id: 0.,
    title: "",
    url: "",
    icon: "",
    showLabel: true,
  }

  let defaultSites: array<t> = [
    {
      id: 0.,
      title: "Lichess",
      url: "https://lichess.org",
      icon: lichessLogo,
      showLabel: false,
    },
    {
      id: 1.,
      title: "Youtube",
      url: "https://youtube.com",
      icon: youtubeLogo,
      showLabel: false,
    },
    {
      id: 11.,
      title: "Codeberg",
      url: "https://codeberg.com",
      icon: codebergLogo,
      showLabel: false,
    },
    {
      id: 2.,
      title: "Github",
      url: "https://github.com",
      icon: githubLogo,
      showLabel: false,
    },
    {
      id: 3.,
      title: "Reddit",
      url: "https://reddit.com",
      icon: redditLogo,
      showLabel: false,
    },
    {
      id: 4.,
      title: "Netflix",
      url: "https://netflix.com",
      icon: netflixLogo,
      showLabel: false,
    },
    {
      id: 5.,
      title: "Duolingo",
      url: "https://duolingo.com",
      icon: duolingoLogo,
      showLabel: false,
    },
    {
      id: 6.,
      title: "Facebook",
      url: "https://facebook.com",
      icon: facebookLogo,
      showLabel: false,
    },
    {
      id: 7.,
      title: "Instagram",
      url: "https://instagram.com",
      icon: instagramLogo,
      showLabel: false,
    },
    {
      id: 8.,
      title: "Whatsapp",
      url: "https://web.whatsapp.com",
      icon: whatsappLogo,
      showLabel: false,
    },
    {
      id: 9.,
      title: "Messenger",
      url: "https://messenger.com",
      icon: messengerLogo,
      showLabel: false,
    },
    {
      id: 10.,
      title: "Spotify",
      url: "https://spotify.com",
      icon: spotifyLogo,
      showLabel: false,
    },
  ]
}

module Page = {
  type t = {
    id: float,
    title: string,
    // icon: string,
    sites: array<Site.t>,
  }

  let defaultPages: array<t> = [
    {
      id: 0.,
      title: "Home",
      // icon: `🏠`,
      sites: Site.defaultSites,
    },
  ]
}

module Icon = {
  type t = {id: float, title: string, src: string}
  let fromSite = (site: Site.t) => {{id: site.id, title: site.title, src: site.icon}}

  let icons: array<t> = [
    {id: 20., title: "Yandex", src: yandexLogo},
    {id: 21., title: "YandexMail", src: yandexMailLogo},
    {id: 22., title: "Gmail", src: gmailLogo},
    {id: 23., title: "Drive", src: driveLogo},
    {id: 24., title: "Image", src: imageLogo},
    {id: 25., title: "Linkedin", src: linkedinLogo},
    {id: 26., title: "Twitter", src: twitterLogo},
    {id: 27., title: "X", src: xLogo},
    {id: 28., title: "Discord", src: discordLogo},
    {id: 29., title: "Openai", src: openaiLogo},
    {id: 30., title: "9gag", src: nineGagLogo},
    {id: 31., title: "Amazon", src: amazonLogo},
    {id: 32., title: "Mangadex", src: mangadexLogo},
    {id: 40., title: "Search", src: searchLogo},
    {id: 41., title: "Link", src: linkLogo},
    {id: 42., title: "UndooLight", src: undooLight},
    {id: 43., title: "UndooBlue", src: undooBlue},
    {id: 50., title: "GlobeGreen", src: globeGreen},
    {id: 51., title: "GlobeRed", src: globeRed},
    {id: 52., title: "GlobeBlue", src: globeBlue},
    {id: 53., title: "GlobeYellow", src: globeYellow},
    {id: 54., title: "GlobePink", src: globePink},
    {id: 55., title: "GlobePurple", src: globePurple},
    {id: 100., title: "Svelte", src: svelteLogo},
    {id: 101., title: "React", src: reactLogo},
    {id: 102., title: "Vue", src: vueLogo},
    {id: 103., title: "Angular", src: angularLogo},
    {id: 104., title: "Django", src: djangoLogo},
  ]
}

module SearchEngine = {
  type t = {
    id: float,
    title: string,
    url: string,
    icon: string,
  }

  let defaultEngines: array<t> = [
    {
      id: 0.,
      title: "Duckduckgo",
      url: "https://duckduckgo.com/?q=<Q>",
      icon: `🦆`,
    },
    {
      id: 1.,
      title: "Startpage",
      url: "https://www.startpage.com/sp/search?query=<Q>",
      icon: `🪿`,
    },
    {
      id: 2.,
      title: "Google",
      url: "https://www.google.com/search?q=<Q>",
      icon: `G`,
    },
  ]
}

module Link = {
  type t = {id: float, title: string, url: string}
}

module OptionTabs = {
  type t = General | Background | ImportExport
}

module View = {
  type t = Page(float) | Searcher | SavedLinks
  let first = pages => pages[0]->Option.map((p: Page.t) => Page(p.id))->Option.getOr(Searcher)
}

// module Shadow = {
//   type size = Xxl | Xl | Md | Sm | Off
//   type color = Primary | Secondary | Accent | Neutral | Default
// }
