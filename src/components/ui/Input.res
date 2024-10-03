let make = props => {
  <label className="form-control w-full flex-col-reverse">
    <input {...props} type_="text" className="input input-bordered w-full" />
    {switch props.label {
    | None => React.null
    | Some(s) =>
      <div className="label">
        <span className="label-text"> {React.string(s)} </span>
      </div>
    }}
  </label>
}
