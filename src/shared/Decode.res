module Json = Js.Json

let decodeObj = json => json->Json.decodeObject
let decodeStr = (obj, key) => obj->Dict.get(key)->Option.flatMap(s => Json.decodeString(s))
let decodeNum = (obj, key) => obj->Dict.get(key)->Option.flatMap(n => Json.decodeNumber(n))
let decodeInt = (obj, key) => obj->decodeStr(key)->Option.flatMap(s => Int.fromString(s))
let decodeBool = (obj, key) => obj->Dict.get(key)->Option.flatMap(n => Json.decodeBoolean(n))
let decodeArr = (obj, key) => obj->Dict.get(key)->Option.flatMap(a => Json.decodeArray(a))

// App Shapes Decoders
let appSite: Json.t => result<Shape.Site.t, string> = json => {
  try {
    let obj = json->decodeObj->Option.getExn
    let id = obj->decodeNum("id")->Option.getExn
    let title = obj->decodeStr("title")->Option.getExn
    let url = obj->decodeStr("url")->Option.getExn
    let icon = obj->decodeStr("icon")->Option.getExn
    let showLabel = obj->decodeBool("showLabel")->Option.getExn
    let bgcolor = obj->decodeStr("bgcolor")->Option.getOr("")

    Ok({
      id,
      title,
      url,
      icon,
      showLabel,
      bgcolor,
    })
  } catch {
  | _ => Error("Decode.appSite: failed to decode json")
  }
}

let appPage: Json.t => result<Shape.Page.t, string> = json => {
  try {
    let obj = json->decodeObj->Option.getExn
    let id = obj->decodeNum("id")->Option.getExn
    let title = obj->decodeStr("title")->Option.getExn
    let sites =
      obj
      ->decodeArr("sites")
      ->Option.flatMap(sites => Some(
        sites->Array.filterMap(s => {
          switch s->appSite {
          | Ok(ok) => Some(ok)
          | Error(_err) => None
          }
        }),
      ))
      ->Option.getExn

    Ok({
      id,
      title,
      sites,
    })
  } catch {
  | _ => Error("Decode.appPage: failed to decode json")
  }
}

let appPages: Json.t => result<array<Shape.Page.t>, string> = json => {
  try {
    let pages =
      json
      ->Json.decodeArray
      ->Option.flatMap(pages => Some(
        pages->Array.filterMap(p => {
          switch p->appPage {
          | Ok(ok) => Some(ok)
          | Error(_err) => None
          }
        }),
      ))
      ->Option.getExn
    Ok(pages)
  } catch {
  | _ => Error("Decode.appPages: failed to decode json")
  }
}

let appSearchEngine: Json.t => result<Shape.SearchEngine.t, string> = json => {
  try {
    let obj = json->decodeObj->Option.getExn
    let id = obj->decodeNum("id")->Option.getExn
    let title = obj->decodeStr("title")->Option.getExn
    let url = obj->decodeStr("url")->Option.getExn
    let icon = obj->decodeStr("icon")->Option.getExn

    Ok({
      id,
      title,
      url,
      icon,
    })
  } catch {
  | _ => Error("Decode.appSearchEngine: failed to decode json")
  }
}

let appSearcher: Json.t => result<array<Shape.SearchEngine.t>, string> = json => {
  try {
    let engines =
      json
      ->Json.decodeArray
      ->Option.flatMap(engine => Some(
        engine->Array.filterMap(e => {
          switch e->appSearchEngine {
          | Ok(ok) => Some(ok)
          | Error(_err) => None
          }
        }),
      ))
      ->Option.getExn
    Ok(engines)
  } catch {
  | _ => Error("Decode.appSearcher: failed to decode json")
  }
}

let appOptions: Json.t => result<Store.Options.t, string> = json => {
  try {
    let obj = json->decodeObj->Option.getExn
    let title = obj->decodeStr("title")->Option.getOr("Undoo Startpage")
    let showPageTitle = obj->decodeBool("showPageTitle")->Option.getOr(true)
    let hideSearcherButton = obj->decodeBool("hideSearcherButton")->Option.getOr(true)
    let hideLinksButton = obj->decodeBool("hideLinksButton")->Option.getOr(false)
    let hideEditButton = obj->decodeBool("hideEditButton")->Option.getOr(false)
    let hideAddButton = obj->decodeBool("hideAddButton")->Option.getOr(false)
    let hideOptionsButton = obj->decodeBool("hideOptionsButton")->Option.getOr(false)
    let hideThemeButton = obj->decodeBool("hideThemeButton")->Option.getOr(false)
    let alwaysShowHints = obj->decodeBool("alwaysShowHints")->Option.getOr(false)
    let alwaysShowSidebar = obj->decodeBool("alwaysShowSidebar")->Option.getOr(false)
    let openLinkInNewTab = obj->decodeBool("openLinkInNewTab")->Option.getOr(false)
    let circleIcons = obj->decodeBool("circleIcons")->Option.getOr(false)
    let hidePageSwitcher = obj->decodeBool("hidePageSwitcher")->Option.getOr(false)

    Ok({
      title,
      showPageTitle,
      hideSearcherButton,
      hideLinksButton,
      hideEditButton,
      hideAddButton,
      hideOptionsButton,
      hideThemeButton,
      hidePageSwitcher,
      alwaysShowHints,
      alwaysShowSidebar,
      openLinkInNewTab,
      circleIcons,
    })
  } catch {
  | _ => Error("Decode.appOptions: failed to decode json")
  }
}

let appBgOptions: Json.t => result<Store.Bg.StoreData.options, string> = json => {
  try {
    let obj = json->decodeObj->Option.getExn
    let image = obj->decodeStr("image")->Option.getExn
    let imageName = obj->decodeStr("imageName")->Option.getExn
    let bgOpacity = obj->decodeInt("bgOpacity")->Option.getExn
    let searcherOpacity = obj->decodeInt("searcherOpacity")->Option.getExn
    let searchOpacity = obj->decodeInt("searchOpacity")->Option.getExn

    Ok({
      image,
      imageName,
      bgOpacity,
      searchOpacity,
      searcherOpacity,
    })
  } catch {
  | _ => Error("Decode.appBgOptions: failed to decode json")
  }
}
