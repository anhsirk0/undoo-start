@module("../assets/gmail.svg") external gmailLogo: string = "default"
@module("../assets/drive.svg") external driveLogo: string = "default"
@module("../assets/yandex.svg") external yandexLogo: string = "default"
@module("../assets/yandex-mail.svg") external yandexMailLogo: string = "default"
@module("../assets/globe-green.svg") external globeGreen: string = "default"
@module("../assets/globe-blue.svg") external globeBlue: string = "default"
@module("../assets/globe-red.svg") external globeRed: string = "default"
@module("../assets/globe-yellow.svg") external globeYellow: string = "default"
@module("../assets/globe-pink.svg") external globePink: string = "default"

include Site

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
    {id: 30, title: "GlobeGreen", src: globeGreen},
    {id: 31, title: "GlobeRed", src: globeRed},
    {id: 32, title: "GlobeBlue", src: globeBlue},
    {id: 33, title: "GlobeYellow", src: globeYellow},
    {id: 34, title: "GlobePink", src: globePink},
  ]
}
