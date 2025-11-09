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

        bookmarks->Array.push({...item, children: Some(otherChildren)})
      }
    | _ => bookmarks->Array.push(item)
    }
  })
  bookmarks
}

let demoTree: treeNode = %raw(`{
    "children": [
        {
            "children": [
                {
                    "dateAdded": 1758369676954,
                    "id": "8",
                    "index": 0,
                    "parentId": "1",
                    "syncing": false,
                    "title": "YouTube",
                    "url": "https://www.youtube.com/"
                }
            ],
            "dateAdded": 1758368125513,
            "dateGroupModified": 1762419374106,
            "folderType": "bookmarks-bar",
            "id": "1",
            "index": 0,
            "parentId": "0",
            "syncing": false,
            "title": "Bookmarks bar"
        },
        {
            "children": [
                {
                    "children": [
        {
            "children": [
                {
                    "dateAdded": 1758369676954,
                    "id": "8",
                    "index": 0,
                    "parentId": "1",
                    "syncing": false,
                    "title": "YouTube",
                    "url": "https://www.youtube.com/"
                }
            ],
            "dateAdded": 1758368125513,
            "dateGroupModified": 1762419374106,
            "folderType": "bookmarks-bar",
            "id": "1",
            "index": 0,
            "parentId": "0",
            "syncing": false,
            "title": "Bookmarks bar"
        },
                        {
                            "dateAdded": 1758369662832,
                            "id": "7",
                            "index": 0,
                            "parentId": "6",
                            "syncing": false,
                            "title": "Panda Notes",
                            "url": "https://notes-panda.netlify.app/"
                        },
                        {
                            "dateAdded": 1758369662832,
                            "id": "17",
                            "index": 0,
                            "parentId": "6",
                            "syncing": false,
                            "title": "Panda Notes",
                            "url": "https://notes-panda.netlify.app/"
                        },
                        {
                            "dateAdded": 1758369662832,
                            "id": "27",
                            "index": 0,
                            "parentId": "6",
                            "syncing": false,
                            "title": "Panda Notes",
                            "url": "https://notes-panda.netlify.app/"
                        },
                        {
                            "dateAdded": 1758369662832,
                            "id": "70",
                            "index": 0,
                            "parentId": "6",
                            "syncing": false,
                            "title": "Panda Notes",
                            "url": "https://notes-panda.netlify.app/"
                        },
                        {
                            "dateAdded": 1762419374106,
                            "id": "10",
                            "index": 1,
                            "parentId": "6",
                            "syncing": false,
                            "title": "Reddit - The heart of the internet",
                            "url": "https://www.reddit.com/"
                        }
                    ],
                    "dateAdded": 1758369643586,
                    "dateGroupModified": 1762419399012,
                    "id": "6",
                    "index": 0,
                    "parentId": "2",
                    "syncing": false,
                    "title": "Stuff"
                },
                {
                    "dateAdded": 1758368183295,
                    "id": "5",
                    "index": 1,
                    "parentId": "2",
                    "syncing": false,
                    "title": "lichess.org • Free Online Chess",
                    "url": "https://lichess.org/"
                },
                {
                    "children": [
                        {
                            "dateAdded": 1762419399012,
                            "id": "11",
                            "index": 0,
                            "parentId": "12",
                            "syncing": false,
                            "title": "Tailwind Collapse Component – daisyUI",
                            "url": "https://daisyui.com/components/collapse/"
                        }
                    ],
                    "dateAdded": 1762419414028,
                    "dateGroupModified": 1762419414029,
                    "id": "12",
                    "index": 2,
                    "parentId": "2",
                    "syncing": false,
                    "title": "DaisyUI"
                }
            ],
            "dateAdded": 1758368125513,
            "dateGroupModified": 1758369662832,
            "folderType": "other",
            "id": "2",
            "index": 1,
            "parentId": "0",
            "syncing": false,
            "title": "Other bookmarks"
        }
    ],
    "dateAdded": 1762419476843,
    "id": "0",
    "syncing": false,
    "title": ""
}`)
