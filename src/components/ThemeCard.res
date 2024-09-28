module MyOverrides = {
  module Elements = {
    // Extend the available lowercase JSX props here.
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
let make = (~theme: string, ~children) => {
  let onClick = _ => Js.log(theme)

  <li className="btn h-10 justify-between w-full" onClick tabIndex={0} dataTheme={theme}>
    {React.string(theme)}
    {children}
  </li>
}
