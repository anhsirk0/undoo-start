type t
type topSites

@val external firefox: t = "browser"
@val external chrome: t = "chrome"

let make = () => {
  try {
    Some(chrome)
  } catch {
  | _ =>
    try {
      Some(firefox)
    } catch {
    | _ => None
    }
  }
}

@get external bookmarks: t => promise<Bookmarks.t> = "bookmarks"

let getAllBookmarks = async () => {
  switch make() {
  | Some(browser) => {
      let bookmarks = await browser->bookmarks
      let tree = await bookmarks->Bookmarks.getTree
      tree[0]->Option.map(Bookmarks.collect)->Option.getOr([])
    }
  | None => []
  }
}

@get external topSites: t => option<topSites> = "topSites"
@send external topSitesGet: topSites => promise<array<Bookmarks.item>> = "get"

let getTopSites = async () => {
  switch make() {
  | Some(browser) =>
    switch browser->topSites {
    | Some(sites) => await sites->topSitesGet
    | None => []
    }
  | None => []
  }
}
