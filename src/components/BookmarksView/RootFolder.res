@react.component
let make = (~folder: Bookmarks.treeNode) => {
  let {options: {reverseBookmarksOrder}} = Store.Options.use()
  let (isSearching, toggleSearching, _) = Hook.useToggle()
  let (query, setQuery) = React.useState(_ => "")

  let folderChildren = React.useMemo3(() => {
    folder.children->Option.map(items => {
      let allItems = reverseBookmarksOrder ? items->Belt.Array.reverse : items
      allItems->Array.filter(
        it =>
          query->Utils.searchContains(it.title) ||
            it.url->Option.filter(url => query->Utils.searchContains(url))->Option.isSome,
      )
    })
  }, (query, folder.children, reverseBookmarksOrder))

  let childrenCount = React.useMemo(() => {
    switch folder.children {
    | Some(kids) => kids->Array.length
    | None => 0
    }
  }, folder.children)

  let onChange = evt => {
    let target = ReactEvent.Form.target(evt)
    let newQuery: string = target["value"]
    setQuery(_ => newQuery)
  }

  let onSearchClick = _ => {
    if !isSearching {
      Utils.querySelectAndThen(`#search-${folder.id}`, Utils.focus)
    } else {
      setQuery(_ => "")
    }
    toggleSearching()
  }

  let className = `flex flex-col gap-4 w-[80%] transitional absolute left-0 ${!isSearching
      ? "-top-[100%]"
      : "top-0"}`

  <div
    className="p-4 flex flex-1 flex-col gap-4 border border-base-content/10 min-h-0 rounded-box min-w-[24%]">
    <div
      className="flex flex-row items-center pb-3 gap-4 border-b border-base-content/10 overflow-hidden relative shrink-0">
      <div className>
        <InputBase
          id={`search-${folder.id}`}
          value=query
          onChange
          name="title"
          className="input border-none focus:outline-none w-full bg-transparent"
          placeholder={`Search in ${folder.title}`}
        />
        <p className="resp-title font-bold w-full truncate">
          {`${folder.title} (${childrenCount->Int.toString})`->React.string}
        </p>
      </div>
      <button onClick=onSearchClick className="btn btn-circle btn-ghost ml-auto">
        <Icon.magnifyingGlass className="size-5" />
      </button>
    </div>
    <div className="flex flex-col gap-4 grow min-h-0 overflow-y-auto">
      {switch folderChildren {
      | Some(kids) =>
        <div className="flex flex-col gap-4 grow min-h-0 overflow-y-auto">
          {kids
          ->Array.map(item => <BookmarksItem.Folder item key=item.id depth=0 />)
          ->React.array}
        </div>
      | None => React.null
      }}
    </div>
  </div>
}
