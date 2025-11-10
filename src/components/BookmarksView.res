type state = Loading | Failed | Root(Bookmarks.treeNode)

module Item = {
  @react.component
  let make = (~item: Bookmarks.treeNode, ~depth=0) => {
    let {options} = Store.Options.use()
    let target = options.openLinkInNewTab ? "_blank" : "_self"
    let favicon =
      item.url->Option.map(url =>
        `https://t3.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=${url}&size=32`
      )
    let bg = depth > 0 ? "bg-base-300" : "bg-base-200"
    <a name="item" href=?item.url target className={`flex flex-col p-4 ${bg} rounded-box w-full`}>
      <div className="flex flex-row items-center gap-4">
        {switch favicon {
        | Some(src) => <img alt=item.title src className="inline size-5" />
        | None => React.null
        }}
        <p className="title line-clamp-2 break-all"> {item.title->React.string} </p>
      </div>
    </a>
  }
}

module rec Folder: {
  @react.component
  let make: (~item: Bookmarks.treeNode, ~depth: int) => React.element
} = {
  @react.component
  let make = (~item: Bookmarks.treeNode, ~depth) => {
    let bg = depth > 0 ? "bg-base-300" : "bg-base-200"

    switch item.children {
    | Some(items) =>
      <div name="item" className={`collapse ${bg} border border-base-200`}>
        <input type_="checkbox" />
        <div className="collapse-title title font-semibold flex flex-row gap-4 items-end">
          <Icon.folder className="resp-icon" />
          {item.title->React.string}
        </div>
        <div className="collapse-content text-sm space-y-2">
          {items
          ->Array.map(item => <Folder item key=item.id depth={depth + 1} />)
          ->React.array}
        </div>
      </div>
    | None => <Item item depth />
    }
  }
}

module RootView = {
  @react.component
  let make = (~items: array<Bookmarks.treeNode>) => {
    let bookmarks = React.useMemo(() => items->Bookmarks.toRootBookmarks, items)

    <div
      className="size-full flex flex-row gap-4 overflow-x-auto"
      onWheel=ReactEvent.Wheel.stopPropagation>
      {bookmarks
      ->Array.map(folder => {
        <div
          key=folder.id
          className="p-4 flex flex-1 flex-col gap-4 border border-base-content/10 min-h-0 rounded-box min-w-[24%]">
          <p className="resp-title text-center font-bold border-b border-base-content/10 w-full">
            {folder.title->React.string}
          </p>
          <div className="flex flex-col gap-4 grow min-h-0 overflow-y-auto">
            {switch folder.children {
            | Some(kids) =>
              <div className="flex flex-col gap-4 grow min-h-0 overflow-y-auto">
                {kids->Array.map(item => <Folder item key=item.id depth=0 />)->React.array}
              </div>
            | None => React.null
            }}
          </div>
        </div>
      })
      ->React.array}
    </div>
  }
}

@react.component
let make = () => {
  let (bookmarks, setBookmarks) = React.useState(_ => Loading)

  React.useEffect0(() => {
    Browser.getBookmarkTree()
    ->Promise.then(async tree =>
      setBookmarks(
        _ =>
          switch tree {
          | Some(node) => Root(node)
          | None => Failed
          },
      )
    )
    ->ignore
    None
  })

  <div className="center size-full z-1">
    {switch bookmarks {
    | Loading => <p className="text-xl"> {"Loading..."->React.string} </p>
    | Failed => <p className="text-xl text-error"> {"Failed to load Bookmarks"->React.string} </p>
    | Root(item) =>
      switch item.children {
      | Some(items) => <RootView items />
      | None => <p className="text-xl"> {"No bookmarks"->React.string} </p>
      }
    }}
  </div>
}
