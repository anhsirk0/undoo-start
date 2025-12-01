module Item = {
  @react.component
  let make = (~item: Bookmarks.treeNode, ~depth=0) => {
    let {options} = Store.Options.use()
    let {options: bgOptions} = Store.Bg.use()

    let target = options.openLinkInNewTab ? "_blank" : "_self"
    let favicon =
      item.url->Option.map(url =>
        `https://t3.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=${url}&size=32`
      )
    let bgcolor = if bgOptions.image->String.length > 20 {
      bgOptions.bookmarkOpacity->Utils.getBgcolor
    } else if depth > 0 {
      "bg-base-300"
    } else {
      "bg-base-200"
    }
    let className = "flex flex-row gap-4 p-4 rounded-box w-full items-center"

    <div id={`bookmark-${item.id}`} target className style={{backgroundColor: bgcolor}}>
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
    let {options: bgOptions} = Store.Bg.use()

    let bgcolor = if bgOptions.image->String.length > 20 {
      bgOptions.bookmarkOpacity->Utils.getBgcolor(~base=depth > 0 ? #300 : #200)
    } else if depth > 0 {
      "var(--color-base-300)"
    } else {
      "var(--color-base-200)"
    }

    switch item.children {
    | Some(items) =>
      <div className="collapse border border-base-200" style={{backgroundColor: bgcolor}}>
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
