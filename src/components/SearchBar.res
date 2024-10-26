open SearchEngine
open Store
open Utils
open Heroicons

module SearchForm = {
  @react.component
  let make = (~engine: SearchEngine.t) => {
    let (value, setValue) = React.useState(_ => "")

    let onChange = evt => {
      let target = JsxEvent.Form.target(evt)
      let newValue: string = target["value"]
      setValue(_ => newValue)
    }

    let store = Store.use()

    let options = SearchEngine.defaultEngines->Array.map(e => {
      let value = e.id->Int.toString
      <option key=value value> {React.string(e.icon)} </option>
    })

    let onSelect = evt => {
      let id = JsxEvent.Form.target(evt)["value"]
      switch id->Int.fromString {
      | Some(id) => store.updateSearchEngineId(id)
      | None => ()
      }
    }

    let onSubmit = evt => {
      JsxEvent.Form.preventDefault(evt)
      // let q = ReactEvent.Form.target(evt)["query"]["value"]
      let target = store.options.openLinkInNewTab ? "_blank" : "_self"
      Utils.openUrl(engine.url->String.replace("<Q>", encodeURI(value)), target)
    }

    let clearText = _ => {
      setValue(_ => "")
      switch ReactDOM.querySelector("input[name='query'") {
      | Some(el) => el->Utils.focus
      | None => ()
      }
    }

    <form onSubmit className="center h-[20vh] w-full p-4 ml-12 join main-width">
      <select
        ariaLabel="select-search-engine"
        className="select select-primary xxl:select-lg join-item"
        value={store.searchEngineId->Int.toString}
        onChange=onSelect>
        {React.array(options)}
      </select>
      <label className="input input-primary xxl:input-lg flex items-center join-item grow">
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
      <button className="btn btn-primary xxl:btn-lg join-item no-animation">
        <Solid.SearchIcon className="resp-icon" />
      </button>
    </form>
  }
}

@react.component
let make = () => {
  let store = Store.use()
  let engine = SearchEngine.defaultEngines->Array.find(e => e.id == store.searchEngineId)

  switch engine {
  | Some(engine) => <SearchForm engine />
  | None => React.null
  }
}
