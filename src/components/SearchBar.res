open Heroicons

module SearchForm = {
  @react.component
  let make = (~engine: Shape.SearchEngine.t) => {
    let (value, setValue) = React.useState(_ => "")

    let onChange = evt => {
      let target = ReactEvent.Form.target(evt)
      let newValue: string = target["value"]
      setValue(_ => newValue)
    }

    let store = Store.Options.use()
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
      Utils.searchLink(engine.url, value, ~target)
    }

    let clearText = _ => {
      setValue(_ => "")
      "input[name='query']"->Utils.querySelectAndThen(Utils.focus)
    }

    <form
      onSubmit
      className="center h-[20vh] w-full p-4 ml-12 w-full max-w-xl xl:wax-w-4xl 2xl:max-w-5xl z-[5]">
      <select
        ariaLabel="select-search-engine"
        id="select-search-engine"
        className="select border-none focus:outline-none 2xl:select-lg bg-base-300 rounded-r-none w-20"
        value={store.searchEngineIdx->Int.toString}
        onChange=onSelect>
        {React.array(options)}
      </select>
      <label
        id="search-input"
        className="input bg-base-300 border-none has-[:focus]:outline-none 2xl:input-lg flex items-center grow w-full rounded-none">
        <InputBase
          value
          onChange
          name="query"
          className="grow"
          placeholder={`Search on ${engine.title}`}
          required=true
          autoComplete="off"
        />
        {value->String.length > 0
          ? <button
              onClick=clearText
              type_="button"
              className="btn btn-sm btn-ghost btn-circle text-base-content/60">
              <Solid.XIcon />
            </button>
          : React.null}
      </label>
      <button
        id="search-btn"
        className="btn btn-ghost bg-base-300 2xl:btn-lg no-animation rounded-l-none shadow-none">
        <Solid.SearchIcon className="resp-icon" />
      </button>
    </form>
  }
}

@react.component
let make = () => {
  let {engines} = Store.SearchEngine.use()
  let store = Store.Options.use()
  let engine = engines->Array.findWithIndex((_, idx) => idx == store.searchEngineIdx)

  switch engine {
  | Some(engine) => <SearchForm engine />
  | None => React.null
  }
}
