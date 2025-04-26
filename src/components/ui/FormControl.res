@react.component
let make = (~label, ~children) => {
  <div className="fieldset w-full flex-col">
    <legend className="fieldset-legend"> {label->React.string} </legend>
    {children}
  </div>
}
