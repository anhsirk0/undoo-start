type t
type item = {
  id: string,
  url: string,
  title: string,
}

type rec treeNode = {
  id: string,
  title: string,
  url: option<string>,
  folderType: option<string>,
  children: option<array<treeNode>>,
}

let toItem: treeNode => option<item> = node => {
  node.url->Option.map(url => {
    id: node.id,
    title: node.title,
    url,
  })
}

@send external getTree: t => promise<array<treeNode>> = "getTree"
@send external remove: (t, string) => promise<unit> = "remove"

let rec collect = node => {
  let base = node->toItem->Option.map(i => [i])->Option.getOr([])
  switch node.children {
  | None => base
  | Some(children) =>
    base->Array.concat(children->Array.reduce([], (acc, it) => acc->Array.concat(it->collect)))
  }
}

let toRootBookmarks = (children: array<treeNode>) => {
  let bookmarks = []
  children->Array.forEach(item => {
    switch item.title {
    | "Other bookmarks" => {
        let otherChildren = []
        item.children
        ->Option.getOr([])
        ->Array.forEach(it => {
          switch it.children {
          | Some(_) => bookmarks->Array.push(it)
          | None => otherChildren->Array.push(it)
          }
        })
        if otherChildren->Array.length > 0 {
          bookmarks->Array.push({...item, children: Some(otherChildren)})
        }
      }
    | "Bookmarks bar" =>
      if item.children->Option.getOr([])->Array.length > 0 {
        bookmarks->Array.push(item)
      }
    | _ => bookmarks->Array.push(item)
    }
  })
  bookmarks
}
