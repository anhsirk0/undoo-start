module MyOverrides = {
  module Elements = {
    type props = {
      ...JsxDOM.domProps,
      @as("data-theme") dataTheme?: string,
    }

    @module("react/jsx-runtime")
    external jsx: (string, props) => Jsx.element = "jsx"

    @module("react/jsx-runtime")
    external jsxs: (string, props) => Jsx.element = "jsx"
    external someElement: Jsx.element => option<Jsx.element> = "%identity"
  }
  @module("react/jsx-runtime")
  external jsx: (React.component<'props>, 'props) => React.element = "jsx"
  external array: array<Jsx.element> => Jsx.element = "%identity"
}

@@jsxConfig({module_: "MyOverrides", mode: "automatic"})

@react.component
let make = (~theme, ~children) => {
  let onClick = _ => {
    Dom.Storage2.setItem(Dom.Storage2.localStorage, "undooStartpageTheme", theme)
    theme->Utils.setTheme
  }

  <li className="btn h-10 justify-between w-full theme-card" onClick tabIndex=0 dataTheme=theme>
    {React.string(theme)}
    {children}
  </li>
}
