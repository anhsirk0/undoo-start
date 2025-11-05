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

let rec collect = node => {
  let base = node->toItem->Option.map(i => [i])->Option.getOr([])
  switch node.children {
  | None => base
  | Some(children) =>
    base->Array.concat(children->Array.reduce([], (acc, it) => acc->Array.concat(it->collect)))
  }
}
