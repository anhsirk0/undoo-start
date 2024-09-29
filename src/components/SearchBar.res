open Heroicons

@val @scope("window")
external openUrl: (string, string) => unit = "open"

@react.component
let make = () => {
  let (value, setValue) = React.useState(_ => "")

  let onSubmit = ev => {
    JsxEvent.Form.preventDefault(ev)
    openUrl("https://duckduckgo.com/?q=" ++ value, "_blank")
  }

  <form onSubmit className="center h-[20vh] w-full p-4 ml-16">
    <label
      className="input input-primary xxl:input-lg flex items-center w-full max-w-3xl xxl:max-w-5xl">
      <input
        name="query"
        type_="text"
        className="grow "
        placeholder="Search"
        onChange={ev => {
          let target = JsxEvent.Form.target(ev)
          let value: string = target["value"]
          setValue(_prevValue => value)
        }}
      />
      <Solid.SearchIcon className="w-8 h-8" />
    </label>
  </form>
}
