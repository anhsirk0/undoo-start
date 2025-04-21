@react.component
let make = (~label, ~children) => {
  <label className="fieldset w-full flex-col">
    <div className="label">
      <span> {React.string(label)} </span>
    </div>
    {children}
  </label>
}
