let make = props => {
  <div className="form-control w-fit">
    <label className="label cursor-pointer flex-row-reverse">
      <input {...props} type_="checkbox" className="checkbox" />
      {switch props.label {
      | Some(s) => <span className="label-text pr-4"> {React.string(s)} </span>
      | None => React.null
      }}
    </label>
  </div>
}
