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

    let options = Shape.SearchEngine.defaultEngines->Array.map(e => {
      let value = e.id->Int.toString
      <option key=value value> {React.string(e.icon)} </option>
    })

    let onSelect = evt => {
      let id = ReactEvent.Form.target(evt)["value"]
      switch id->Int.fromString {
      | Some(id) => store.updateSearchEngineId(id)
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
      className="center h-[20vh] w-full p-4 ml-12 w-full max-w-xl xl:wax-w-4xl xxl:max-w-5xl z-[5]">
      <select
        ariaLabel="select-search-engine"
        id="select-search-engine"
        className="select xxl:select-lg bg-base-300 rounded-r-none"
        value={store.searchEngineId->Int.toString}
        onChange=onSelect>
        {React.array(options)}
      </select>
      <label
        id="search-input"
        className="input has-[:focus]:border-none has-[:focus]:outline-none bg-base-300 xxl:input-lg flex items-center grow rounded-none">
        <InputBase
          value
          onChange
          name="query"
          className="grow"
          placeholder={`Search on ${engine.title}`}
          required=true
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
        className="btn btn-ghost bg-base-300 xxl:btn-lg no-animation rounded-l-none">
        <Solid.SearchIcon className="resp-icon" />
      </button>
    </form>
  }
}

@react.component
let make = () => {
  let store = Store.Options.use()
  let engine = Shape.SearchEngine.defaultEngines->Array.find(e => e.id == store.searchEngineId)

  switch engine {
  | Some(engine) => <SearchForm engine />
  | None => React.null
  }
}
