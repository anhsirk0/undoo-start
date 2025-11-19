module Item = {
  @react.component
  let make = (~item: Bookmarks.treeNode, ~depth=0) => {
    let {options} = Store.Options.use()

    let target = options.openLinkInNewTab ? "_blank" : "_self"
    let favicon =
      item.url->Option.map(url =>
        `https://t3.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=${url}&size=32`
      )
    let className = `flex flex-row gap-4 p-4 rounded-box w-full items-center ${depth > 0
        ? "bg-base-300"
        : "bg-base-200"}`

    <div id={`bookmark-${item.id}`} name="bookmark-item" target className>
      <a href=?item.url className="flex flex-row items-center gap-4 grow">
        {switch favicon {
        | Some(src) => <img alt=item.title src className="inline size-5" />
        | None => React.null
        }}
        <p className="title line-clamp-2 break-all"> {item.title->React.string} </p>
      </a>
      <BookmarksOptions item />
    </div>
  }
}

module rec Folder: {
  @react.component
  let make: (~item: Bookmarks.treeNode, ~depth: int) => React.element
} = {
  @react.component
  let make = (~item: Bookmarks.treeNode, ~depth) => {
    let {options: {reverseBookmarksOrder}} = Store.Options.use()
    let bg = depth > 0 ? "bg-base-300" : "bg-base-200"

    switch item.children {
    | Some(items) =>
      <div name="bookmark-item" className={`collapse ${bg} border border-base-200`}>
        <input type_="checkbox" />
        <div className="collapse-title title font-semibold flex flex-row gap-4 items-end">
          <Icon.folder className="resp-icon" />
          {item.title->React.string}
        </div>
        <div className="collapse-content text-sm space-y-2">
          {(reverseBookmarksOrder ? items->Belt.Array.reverse : items)
          ->Array.map(item => <Folder item key=item.id depth={depth + 1} />)
          ->React.array}
        </div>
      </div>
    | None => <Item item depth />
    }
  }
}
