module SearchForm = {
  @react.component
  let make = (~engine: Shape.SearchEngine.t, ~query, ~setQuery) => {
    let onChange = evt => {
      let target = ReactEvent.Form.target(evt)
      let newQuery: string = target["value"]
      setQuery(_ => newQuery)
    }

    let store = Store.Options.use()
    let {options: bgOptions} = Store.Bg.use()
    let {engines} = Store.SearchEngine.use()

    let options = engines->Array.mapWithIndex((e, idx) => {
      let value = idx->Int.toString
      <option key=value value> {React.string(e.icon)} </option>
    })

    let onSelect = evt => {
      let id = ReactEvent.Form.target(evt)["value"]
      switch id->Int.fromString {
      | Some(id) => store.updateSearchEngineIdx(id)
      | None => ()
      }
    }

    let onSubmit = evt => {
      ReactEvent.Form.preventDefault(evt)
      // let q = ReactEvent.Form.target(evt)["query"]["value"]
      let target = store.options.openLinkInNewTab ? "_blank" : "_self"
      Utils.searchLink(engine.url, query, ~target)
    }

    let clearText = _ => {
      setQuery(_ => "")
      "input[name='query']"->Utils.querySelectAndThen(Utils.focus)
    }

    let bgcolor =
      bgOptions.image->String.length > 20
        ? Utils.getBgcolor(bgOptions.searchOpacity)
        : "var(--color-base-300)"

    <form
      onSubmit
      onWheel=ReactEvent.Wheel.stopPropagation
      onContextMenu=ReactEvent.Mouse.stopPropagation
      className="center h-[20vh] w-full p-4 ml-12 w-full max-w-xl xl:wax-w-4xl 2xl:max-w-5xl z-[5]"
    >
      <select
        ariaLabel="select-search-engine"
        id="select-search-engine"
        className="select border-none focus:outline-none 2xl:select-lg rounded-r-none w-20"
        value={store.searchEngineIdx->Int.toString}
        onChange=onSelect
        style={{backgroundColor: bgcolor}}
      >
        {React.array(options)}
      </select>
      <label
        id="search-input"
        className="input border-none has-[:focus]:outline-none 2xl:input-lg flex items-center grow w-full rounded-none"
        style={{backgroundColor: bgcolor}}
      >
        <InputBase
          value=query
          onChange
          name="query"
          className="grow"
          placeholder={`Search on ${engine.title}`}
          required=true
          autoComplete="off"
        />
        {query->String.length > 0
          ? <button
              onClick=clearText
              type_="button"
              className="btn btn-sm btn-ghost btn-circle text-base-content/60"
            >
              <Icon.x />
            </button>
          : React.null}
      </label>
      <button
        id="search-btn"
        className="btn btn-ghost 2xl:btn-lg no-animation rounded-l-none shadow-none"
        style={{backgroundColor: bgcolor}}
      >
        <Icon.magnifyingGlass className="resp-icon" />
      </button>
    </form>
  }
}

@react.component
let make = (~query, ~setQuery) => {
  let {engines} = Store.SearchEngine.use()
  let store = Store.Options.use()
  let engine = engines->Array.findWithIndex((_, idx) => idx == store.searchEngineIdx)

  switch engine {
  | Some(engine) => <SearchForm engine query setQuery />
  | None => React.null
  }
}
