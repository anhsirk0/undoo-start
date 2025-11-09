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

@get external bookmarks: t => option<promise<Bookmarks.t>> = "bookmarks"

let getBookmarkTree = async () => {
  switch make() {
  | Some(browser) =>
    switch browser->bookmarks {
    | Some(fn) => {
        let bookmarks = await fn
        let tree = await bookmarks->Bookmarks.getTree
        tree[0]
      }
    | None => None
    }
  | None => None
  }
}

let getAllBookmarks = async () => {
  let tree = await getBookmarkTree()
  switch tree {
  | Some(node) => node->Bookmarks.collect
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
