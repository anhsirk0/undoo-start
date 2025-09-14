@react.component
let make = (~label=?, ~children) => {
  <div className="fieldset w-full flex-col">
    {switch label {
    | Some(label) => <legend className="fieldset-legend"> {label->React.string} </legend>
    | None => React.null
    }}
    {children}
  </div>
}
