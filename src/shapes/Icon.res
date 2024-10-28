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
@module("../assets/discord.svg") external discordLogo: string = "default"
@module("../assets/openai.svg") external openaiLogo: string = "default"
@module("../assets/undoo-blue.svg") external undooBlue: string = "default"
@module("../assets/undoo-light.svg") external undooLight: string = "default"

open Site

module Icon = {
  type t = {
    id: int,
    title: string,
    src: string,
  }
  let fromSite = (site: Site.t) => {{id: site.id, title: site.title, src: site.icon}}

  let icons: array<t> = [
    {id: 20, title: "Yandex", src: yandexLogo},
    {id: 21, title: "YandexMail", src: yandexMailLogo},
    {id: 22, title: "Gmail", src: gmailLogo},
    {id: 23, title: "Drive", src: driveLogo},
    {id: 24, title: "Image", src: imageLogo},
    {id: 25, title: "Linkedin", src: linkedinLogo},
    {id: 26, title: "Twitter", src: twitterLogo},
    {id: 27, title: "Discord", src: discordLogo},
    {id: 29, title: "Openai", src: openaiLogo},
    {id: 30, title: "Search", src: searchLogo},
    {id: 31, title: "Link", src: linkLogo},
    {id: 32, title: "UndooLight", src: undooLight},
    {id: 33, title: "UndooBlue", src: undooBlue},
    {id: 40, title: "GlobeGreen", src: globeGreen},
    {id: 41, title: "GlobeRed", src: globeRed},
    {id: 42, title: "GlobeBlue", src: globeBlue},
    {id: 43, title: "GlobeYellow", src: globeYellow},
    {id: 44, title: "GlobePink", src: globePink},
    {id: 45, title: "GlobePurple", src: globePurple},
  ]
}
