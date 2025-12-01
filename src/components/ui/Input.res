@Jsx.element
let make = props => {
  let children = <InputBase {...props} className="input 2xl:input-lg w-full" />
  <FormControl label=?props.label> {children} </FormControl>
}
