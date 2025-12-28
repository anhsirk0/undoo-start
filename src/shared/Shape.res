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
    showLabel: false,
  }

  let guessIconFromUrl = url => {
    if url->String.includes("duckduckgo.com") || url->String.includes("duck.ai") {
      SvgIcon.duckduckgoLogo
    } else if url->String.includes("lichess.org") {
      SvgIcon.lichessLogo
    } else if url->String.includes("whatsapp.com") {
      SvgIcon.whatsappLogo
    } else if url->String.includes("github.com") {
      SvgIcon.githubLogo
    } else if url->String.includes("codeberg.org") {
      SvgIcon.codebergLogo
    } else if url->String.includes("netflix.com") {
      SvgIcon.netflixLogo
    } else if url->String.includes("reddit.com") {
      SvgIcon.redditLogo
    } else if url->String.includes("instagram.com") {
      SvgIcon.instagramLogo
    } else if url->String.includes("facebook.com") {
      SvgIcon.facebookLogo
    } else if url->String.includes("mail.google") {
      SvgIcon.gmailLogo
    } else if url->String.includes("spotify.com") {
      SvgIcon.spotifyLogo
    } else if url->String.includes("x.com") {
      SvgIcon.xLogo
    } else if url->String.includes("discord.com") {
      SvgIcon.discordLogo
    } else if url->String.includes("chatgpt.com") {
      SvgIcon.openaiLogo
    } else if url->String.includes("drive.google") {
      SvgIcon.driveLogo
    } else if url->String.includes("duolingo.com") {
      SvgIcon.duolingoLogo
    } else if url->String.includes("9gag.com") {
      SvgIcon.nineGagLogo
    } else if url->String.includes("amazon.") {
      SvgIcon.amazonLogo
    } else if url->String.includes("mangadex.org") {
      SvgIcon.mangadexLogo
    } else if url->String.includes("yandex.com") && url->String.includes("mail") {
      SvgIcon.yandexLogo
    } else if url->String.includes("yandex.com") {
      SvgIcon.yandexLogo
    } else {
      SvgIcon.navigation
    }
  }

  let fromBookmark = (item: Bookmarks.item, idx) => {
    let id = Date.now() +. idx->Int.toFloat
    let icon = item.url->guessIconFromUrl
    {
      id,
      title: item.title,
      url: item.url,
      icon,
      showLabel: icon == SvgIcon.navigation,
    }
  }

  let defaultSites: array<t> = [
    {
      id: 0.,
      title: "Lichess",
      url: "https://lichess.org",
      icon: SvgIcon.lichessLogo,
      showLabel: false,
    },
    {
      id: 1.,
      title: "Youtube",
      url: "https://youtube.com",
      icon: SvgIcon.youtubeLogo,
      showLabel: false,
    },
    {
      id: 11.,
      title: "Codeberg",
      url: "https://codeberg.org",
      icon: SvgIcon.codebergLogo,
      showLabel: false,
    },
    {
      id: 2.,
      title: "Github",
      url: "https://github.com",
      icon: SvgIcon.githubLogo,
      showLabel: false,
    },
    {
      id: 3.,
      title: "Reddit",
      url: "https://reddit.com",
      icon: SvgIcon.redditLogo,
      showLabel: false,
    },
    {
      id: 4.,
      title: "Netflix",
      url: "https://netflix.com",
      icon: SvgIcon.netflixLogo,
      showLabel: false,
    },
    {
      id: 5.,
      title: "Duolingo",
      url: "https://duolingo.com",
      icon: SvgIcon.duolingoLogo,
      showLabel: false,
    },
    {
      id: 6.,
      title: "Facebook",
      url: "https://facebook.com",
      icon: SvgIcon.facebookLogo,
      showLabel: false,
    },
    {
      id: 7.,
      title: "Instagram",
      url: "https://instagram.com",
      icon: SvgIcon.instagramLogo,
      showLabel: false,
    },
    {
      id: 8.,
      title: "Whatsapp",
      url: "https://web.whatsapp.com",
      icon: SvgIcon.whatsappLogo,
      showLabel: false,
    },
    {
      id: 9.,
      title: "Messenger",
      url: "https://messenger.com",
      icon: SvgIcon.messengerLogo,
      showLabel: false,
    },
    {
      id: 10.,
      title: "Spotify",
      url: "https://spotify.com",
      icon: SvgIcon.spotifyLogo,
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

  let fromTopSites: array<Bookmarks.item> => array<t> = sites => [
    {id: 0., title: "Home", sites: sites->Array.mapWithIndex(Site.fromBookmark)},
  ]
}

module Icon = {
  type t = {id: float, title: string, src: string}
  let fromSite = (site: Site.t) => {{id: site.id, title: site.title, src: site.icon}}

  let icons: array<t> = [
    {id: 20., title: "Yandex", src: SvgIcon.yandexLogo},
    {id: 21., title: "YandexMail", src: SvgIcon.yandexMailLogo},
    {id: 22., title: "Gmail", src: SvgIcon.gmailLogo},
    {id: 23., title: "Drive", src: SvgIcon.driveLogo},
    {id: 24., title: "Image", src: SvgIcon.imageLogo},
    {id: 25., title: "Linkedin", src: SvgIcon.linkedinLogo},
    {id: 26., title: "Twitter", src: SvgIcon.twitterLogo},
    {id: 27., title: "X", src: SvgIcon.xLogo},
    {id: 28., title: "Discord", src: SvgIcon.discordLogo},
    {id: 29., title: "Openai", src: SvgIcon.openaiLogo},
    {id: 30., title: "9gag", src: SvgIcon.nineGagLogo},
    {id: 31., title: "Amazon", src: SvgIcon.amazonLogo},
    {id: 32., title: "Mangadex", src: SvgIcon.mangadexLogo},
    {id: 40., title: "Search", src: SvgIcon.searchLogo},
    {id: 41., title: "Duckduckgo", src: SvgIcon.duckduckgoLogo},
    {id: 42., title: "Startpage", src: SvgIcon.startpageLogo},
    {id: 43., title: "Link", src: SvgIcon.linkLogo},
    {id: 44., title: "Navigation", src: SvgIcon.navigation},
    {id: 45., title: "ColorSquare", src: SvgIcon.colorSquare},
    {id: 46., title: "Menu", src: SvgIcon.menu},
    {id: 47., title: "Star", src: SvgIcon.star},
    {id: 48., title: "Clock", src: SvgIcon.clock},
    {id: 100., title: "Svelte", src: SvgIcon.svelteLogo},
    {id: 101., title: "React", src: SvgIcon.reactLogo},
    {id: 102., title: "Vue", src: SvgIcon.vueLogo},
    {id: 103., title: "Angular", src: SvgIcon.angularLogo},
    {id: 104., title: "Django", src: SvgIcon.djangoLogo},
    {id: 105., title: "NoFace", src: SvgIcon.noFace},
    {id: 106., title: "Butterfly", src: SvgIcon.butterfly},
    {id: 107., title: "Pencil", src: SvgIcon.pencil},
    {id: 109., title: "StickyNote", src: SvgIcon.stickyNote},
    {id: 110., title: "Heart", src: SvgIcon.heart},
    {id: 144., title: "UndooLight", src: SvgIcon.undooLight},
    {id: 145., title: "UndooBlue", src: SvgIcon.undooBlue},
    {id: 150., title: "GlobeGreen", src: SvgIcon.globeGreen},
    {id: 151., title: "GlobeRed", src: SvgIcon.globeRed},
    {id: 152., title: "GlobeBlue", src: SvgIcon.globeBlue},
    {id: 153., title: "GlobeYellow", src: SvgIcon.globeYellow},
    {id: 154., title: "GlobePink", src: SvgIcon.globePink},
    {id: 155., title: "GlobePurple", src: SvgIcon.globePurple},
  ]
}

module SearchEngine = {
  type t = {
    id: float,
    title: string,
    url: string,
    icon: string,
  }
  let eq = (one, other) => one.id == other.id
  let make = () => {id: Date.now(), title: "", url: "", icon: "New"}
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
    {
      id: 3.,
      title: "Youtube",
      url: "https://www.youtube.com/results?search_query=<Q>",
      icon: `YT`,
    },
  ]
}

module OptionTabs = {
  type t = General | Background | ImportExport | SearchEngine
}

module Action = {
  type t = Searcher | History | Bookmarks
  let fromUrlString = str =>
    switch str {
    | "action:searcher" => Some(Searcher)
    | "action:history" => Some(History)
    | "action:bookmarks" => Some(Bookmarks)
    | _ => None
    }
}

module View = {
  type t = Page(float) | Action(Action.t) | Loading
  let first = pages =>
    pages[0]->Option.map((p: Page.t) => Page(p.id))->Option.getOr(Action(Searcher))
}
