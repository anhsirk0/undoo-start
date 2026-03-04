module SearchForm = {
  @react.component
  let make = (~engine: Shape.SearchEngine.t, ~query, ~setQuery) => {
    let (openLinkInNewTab, searchEngineIdx, updateSearchEngineIdx) = Store.Options.useShallow(s => (
      s.options.openLinkInNewTab,
      s.searchEngineIdx,
      s.updateSearchEngineIdx,
    ))
    let (image, searchOpacity) = Store.Bg.useShallow(s => (
      s.options.image,
      s.options.searchOpacity,
    ))
    let engines = Store.SearchEngine.useShallow(s => s.engines)

    let onChange = evt => {
      let target = ReactEvent.Form.target(evt)
      let newQuery: string = target["value"]
      setQuery(_ => newQuery)
    }

    let options = engines->Array.mapWithIndex((e, idx) => {
      let value = idx->Int.toString
      <option key=value value> {React.string(e.icon)} </option>
    })

    let onSelect = evt => {
      let id = ReactEvent.Form.target(evt)["value"]
      switch id->Int.fromString {
      | Some(id) => updateSearchEngineIdx(id)
      | None => ()
      }
    }

    let onSubmit = evt => {
      ReactEvent.Form.preventDefault(evt)
      // let q = ReactEvent.Form.target(evt)["query"]["value"]
      let target = openLinkInNewTab ? "_blank" : "_self"
      Utils.searchLink(engine.url, query, ~target)
    }

    let clearText = _ => {
      setQuery(_ => "")
      "input[name='query']"->Utils.querySelectAndThen(Utils.focus)
    }

    let bgcolor =
      image->String.length > 20 ? Utils.getBgcolor(searchOpacity) : "var(--color-base-300)"

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
        value={searchEngineIdx->Int.toString}
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
  let engines = Store.SearchEngine.useShallow(s => s.engines)
  let searchEngineIdx = Store.Options.useShallow(s => s.searchEngineIdx)

  let engine = engines->Array.findWithIndex((_, idx) => idx == searchEngineIdx)

  switch engine {
  | Some(engine) => <SearchForm engine query setQuery />
  | None => React.null
  }
}
