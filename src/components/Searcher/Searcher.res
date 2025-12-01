@react.component
let make = (~query, ~setQuery) => {
  Hook.useDocTitle(Some("Searcher"))
  let {isEditing} = Store.View.use()
  let {options} = Store.Bg.use()
  let useBg = options.image->String.length > 20

  let onChange = evt => {
    let target = ReactEvent.Form.target(evt)
    let newQuery: string = target["value"]
    setQuery(_ => newQuery)
  }

  let store = Store.Searcher.use()
  let isAllChecked = store.engines->Array.every(e => store.checkedIds->Array.includes(e.id))
  let toggleAll = _ => store.toggleAll(isAllChecked)
  let count = store.engines->Array.filter(e => store.checkedIds->Array.includes(e.id))->Array.length

  let onSubmit = evt => {
    ReactEvent.Form.preventDefault(evt)
    // let q = ReactEvent.Form.target(evt)["query"]["value"]

    store.engines
    ->Array.filter(e => store.checkedIds->Array.includes(e.id))
    ->Array.forEach(e => Utils.searchLink(e.url, query))
  }

  let clearText = _ => {
    setQuery(_ => "")
    "input[name='query']"->Utils.querySelectAndThen(Utils.focus)
  }

  let bgcolor = useBg ? Utils.getBgcolor(options.searcherOpacity) : "var(--color-base-300)"

  let items = store.engines->Array.map(item => {
    let checked = store.checkedIds->Array.includes(item.id)
    let toggleOne = _ => store.toggleOne(item.id, checked)
    let onDelete = _ => store.deleteEngine(item.id)

    let onClick = evt => {
      evt->ReactEvent.Mouse.stopPropagation
      if query->String.length > 0 {
        Utils.searchLink(item.url, query)
      }
    }

    // let opacity = checked ? "bg-primary/20" : "opacity-80"

    <div
      key={item.id->Float.toString}
      className="col-span-6 md:col-span-4 animate-fade rounded-box relative overflow-hidden"
      style={{backgroundColor: bgcolor}}
      name="searcher-item">
      <div
        role="button"
        ariaLabel={`search-${item.title}`}
        onClick
        className="flex flex-col h-full gap-4 p-4 2xl:p-6 cursor-pointer">
        <div className="flex flex-row space-between w-full">
          <p className="card-title w-full"> {item.title->React.string} </p>
          <Checkbox checked onChange=toggleOne />
        </div>
        <p className="text-base-content/60 title">
          {item.url->String.replace("https://", "")->React.string}
        </p>
      </div>
      {isEditing ? <EditSearcherButton engine=item /> : React.null}
      {isEditing
        ? <div
            className="center absolute left-0 bottom-0 bg-error text-error-content rounded-tr-box p-1">
            <div className="dropdown dropdown-end dropdown-right">
              <label ariaLabel={`delete-${item.title}`} tabIndex=0>
                <Icon.trash className="resp-icon" />
              </label>
              <div
                tabIndex=0
                className="dropdown-content z-[1] card card-compact w-64 xl:w-72 -ml-6 px-2 py-1 shadow bg-error">
                <div className="flex flex-row items-center justify-between p-2">
                  <h3 className="text-base xl:text-xl font-bold">
                    {"Are you sure?"->React.string}
                  </h3>
                  <button type_="button" className="btn btn-neutral resp-btn" onClick=onDelete>
                    {"Yes, Delete"->React.string}
                  </button>
                </div>
              </div>
            </div>
          </div>
        : React.null}
    </div>
  })

  // React.useEffect2(() => {
  //   if useBg {
  //     Document.querySelectorAll("[name=searcher-item]")->Array.forEach(el =>
  //       el->Utils.setBg(options.searcherOpacity)
  //     )
  //   }
  //   None
  // }, (options.searcherOpacity, useBg))

  <React.Fragment>
    <form
      onWheel=ReactEvent.Wheel.stopPropagation
      onSubmit
      className="center h-[20vh] p-4 ml-12 w-full max-w-xl xl:wax-w-4xl 2xl:max-w-5xl shrink-0 z-[5]">
      <div
        id="searcher"
        className="center h-10 2xl:h-12 w-16 gap-2 rounded-l-field"
        style={{backgroundColor: bgcolor}}>
        <Checkbox checked=isAllChecked onChange=toggleAll />
        {count > 0
          ? <p className="text-lg text-primary"> {count->Int.toString->React.string} </p>
          : React.null}
      </div>
      <label
        id="search-input"
        className="input border-none has-[:focus]:outline-none 2xl:input-lg flex items-center join-item grow rounded-none ms-0"
        style={{backgroundColor: bgcolor}}>
        <InputBase
          required=true name="query" className="grow" value=query onChange placeholder="Search"
        />
        {query->String.length > 0
          ? <button
              onClick=clearText
              type_="button"
              className="btn btn-sm btn-ghost btn-circle text-base-content/60">
              <Icon.x />
            </button>
          : React.null}
      </label>
      <button
        id="search-btn"
        className="btn btn-ghost 2xl:btn-lg join-item no-animation rounded-l-none ms-0"
        style={{backgroundColor: bgcolor}}>
        <Icon.magnifyingGlass className="resp-icon" />
      </button>
    </form>
    <div className="center px-4 2xl:py-4 ml-12 join main-width 2xl:max-w-7xl z-[5]">
      <div className="grid grid-cols-12 gap-4 xl:gap-8 w-full"> {React.array(items)} </div>
      <AddSearcherButton />
    </div>
  </React.Fragment>
}
