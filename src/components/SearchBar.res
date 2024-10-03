open Heroicons

@val @scope("window")
external openUrl: (string, string) => unit = "open"

@react.component
let make = () => {
  let onSubmit = evt => {
    JsxEvent.Form.preventDefault(evt)
    let q = ReactEvent.Form.target(evt)["query"]["value"]
    openUrl("https://duckduckgo.com/?q=" ++ q, "_blank")
  }

  <form onSubmit className="center h-[20vh] w-full p-4 ml-16">
    <label
      className="input input-primary xxl:input-lg flex items-center w-full max-w-3xl xxl:max-w-5xl">
      <input name="query" type_="text" className="grow " placeholder="Search on Duckduckgo" />
      <Solid.SearchIcon className="resp-icon" />
    </label>
  </form>
}
