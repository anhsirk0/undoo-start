type state = Loading | Failed | Root(Bookmarks.treeNode)

module RootView = {
  @react.component
  let make = (~items: array<Bookmarks.treeNode>) => {
    let bookmarks = React.useMemo(() => items->Bookmarks.toRootBookmarks, items)

    <div
      className="size-full flex flex-row gap-4 overflow-x-auto animate-fade"
      onWheel=ReactEvent.Wheel.stopPropagation>
      {bookmarks
      ->Array.map(folder => <RootFolder folder key=folder.id />)
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
      setBookmarks(_ => tree->Option.map(node => Root(node))->Option.getOr(Failed))
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
