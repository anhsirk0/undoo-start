open Heroicons

@react.component
let make = () => {
  let onClick = ev => {
    JsxEvent.Mouse.stopPropagation(ev)
    Js.log("here")
  }

  <div className="bg-base-100/70 absolute inset-0 size-full center" onClick>
    <Solid.PencilIcon className="w-10 h-10 text-base-content" />
  </div>
}
