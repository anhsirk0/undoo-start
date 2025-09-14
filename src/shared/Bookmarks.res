type t
type browser

type item = {
  id: string,
  url: string,
  title: string,
}

module TreeNode = {
  type kind = Bookmark | Separator | Folder
  type rec t = {
    id: string,
    title: string,
    url: option<string>,
    children: option<array<t>>,
    @as("type") kind: option<kind>,
  }
}

@val external firefoxBrowser: browser = "browser"
@val external chromeBrowser: browser = "chrome"

@get external make: browser => promise<t> = "bookmarks"

@send external getTree: t => promise<array<TreeNode.t>> = "getTree"
@send external getChildren: t => promise<array<TreeNode.t>> = "getChildren"

let getBrowser = () => {
  try {
    Some(chromeBrowser)
  } catch {
  | _ =>
    try {
      Some(firefoxBrowser)
    } catch {
    | _ => None
    }
  }
}

let toItem: TreeNode.t => option<item> = node => {
  node.url->Option.map(url => {
    id: node.id,
    title: node.title,
    url,
  })
}

let rec collect: TreeNode.t => array<item> = node => {
  let base = toItem(node)->Option.map(i => [i])->Option.getOr([])
  switch node.children {
  | Some(children) =>
    base->Array.concat(children->Array.reduce([], (acc, it) => acc->Array.concat(it->collect)))
  | None => base
  }
}

let getAll = async () => {
  switch getBrowser() {
  | Some(browser) => {
      let bookmarks = await browser->make
      let tree = await bookmarks->getTree
      tree[0]->Option.map(collect)->Option.getOr([])
    }
  | None => []
  }
}
