include SearchEngine
include Store

open Heroicons

@val @scope("window")
external openUrl: (string, string) => unit = "open"

module SearchForm = {
  @react.component
  let make = (~engine: SearchEngine.t) => {
    let store = Store.use()

    let options = SearchEngine.defaultEngines->Array.map(e => {
      let value = e.id->Int.toString
      <option key=value value> {React.string(e.icon)} </option>
    })

    let onChange = evt => {
      let id = JsxEvent.Form.target(evt)["value"]
      switch id->Int.fromString {
      | Some(id) => store.updateSearchEngineId(id)
      | None => ()
      }
    }

    let onSubmit = evt => {
      JsxEvent.Form.preventDefault(evt)
      let q = ReactEvent.Form.target(evt)["query"]["value"]
      let target = store.openLinkInNewTab ? "_blank" : "_self"
      openUrl(engine.url->String.replace("<Q>", q), target)
    }

    <form onSubmit className="center h-[20vh] w-full p-4 ml-16 join w-full max-w-3xl xxl:max-w-5xl">
      <select
        ariaLabel="select-search-engine"
        className="select select-primary xxl:select-lg join-item"
        value={store.searchEngineId->Int.toString}
        onChange>
        {React.array(options)}
      </select>
      <label className="input input-primary xxl:input-lg flex items-center join-item grow">
        <input name="query" className="grow" placeholder={`Search on ${engine.title}`} />
        <Solid.SearchIcon className="resp-icon" />
      </label>
    </form>
  }
}

@react.component
let make = () => {
  let store = Store.use()
  // let (id, setId) = React.useState(_ => SearchEngine.defaultEngines[0]->Option.map(e => e.id))
  let engine = SearchEngine.defaultEngines->Array.find(e => e.id == store.searchEngineId)

  switch engine {
  | Some(engine) => <SearchForm engine />
  | None => React.null
  }
}
