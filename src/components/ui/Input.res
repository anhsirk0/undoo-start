@Jsx.element
let make = props => {
  let children =
    <InputBase {...props} className="input input-bordered input-sm xxl:input-md w-full" />
  <FormControl label={props.label->Option.getOr("")}> {children} </FormControl>
}
