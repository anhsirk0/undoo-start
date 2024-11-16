open ReactEvent

@react.element
let make = props => {
  let el = React.useRef(Nullable.null)
  let onKeyDown = evt => {
    evt->Keyboard.stopPropagation
    if Keyboard.key(evt) == "Escape" {
      el.current->Nullable.forEach(input => input->Utils.blur)
    }
  }

  <input {...props} onKeyDown ref={ReactDOM.Ref.domRef(el)} />
}
