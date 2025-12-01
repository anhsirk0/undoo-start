module BookmarkCard = {
  @react.component
  let make = (~item: Bookmarks.item, ~active, ~onClick) => {
    let className = `flex flex-col rounded-box w-full p-4 bg-accent/25 cursor-pointer border-2 ${active
        ? "border-accent"
        : "border-transparent"}`
    <div role="button" key=item.id onClick className>
      <p className="text-base xl:text-lg 2xl:text-xl text-base-content truncate">
        {item.title->React.string}
      </p>
      <p className="title text-base-content/80 truncate"> {item.url->React.string} </p>
    </div>
  }
}

@react.component
let make = (~bookmarks: array<Bookmarks.item>, ~onSubmit, ~onClose) => {
  let (query, setQuery) = React.useState(_ => "")
  let (chosen, setChosen) = React.useState(_ => None)

  let onChange = evt => {
    let target = ReactEvent.Form.target(evt)
    let newQuery: string = target["value"]
    setQuery(_ => newQuery)
  }

  let filteredBookmarks = React.useMemo2(() => {
    bookmarks->Array.filter(it =>
      query->Utils.searchContains(it.title) || query->Utils.searchContains(it.url)
    )
  }, (query, bookmarks))

  let onClick = _ => chosen->Option.map(onSubmit)->ignore

  <div className="flex flex-col min-h-0 h-full w-full gap-4">
    <div className="flex flex-row gap-4 items-center">
      <button onClick={_ => onClose()} type_="button" className="btn btn-ghost btn-square resp-btn">
        <Icon.arrowLeft className="resp-icon" />
      </button>
      <Input value=query onChange name="icon" placeholder="Search bookmarks" />
      <button onClick className="btn btn-primary resp-btn"> {"Choose"->React.string} </button>
    </div>
    <div className="flex flex-col gap-4 min-h-0 overflow-y-auto h-full">
      {filteredBookmarks
      ->Array.map(item =>
        <BookmarkCard
          item onClick={_ => setChosen(_ => Some(item))} active={chosen == Some(item)}
        />
      )
      ->React.array}
    </div>
  </div>
}
