@Jsx.element
let make = props => {
  <label className="form-control w-full flex-col-reverse">
    <InputBase {...props} className="input input-bordered w-full" />
    {switch props.label {
    | Some(s) =>
      <div className="label">
        <span className="label-text"> {React.string(s)} </span>
      </div>
    | None => React.null
    }}
  </label>
}
