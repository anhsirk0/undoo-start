@react.component
let make = (~label, ~children) => {
  <label className="form-control w-full flex-col">
    <div className="label">
      <span className="label-text"> {React.string(label)} </span>
    </div>
    {children}
  </label>
}
