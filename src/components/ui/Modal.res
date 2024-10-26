open Utils
open ReactEvent

@react.component
let make = (~title, ~onClose, ~children, ~classes=?) => {
  let className = "modal-box flex flex-col max-h-[94vh] min-w-[36vw] " ++ classes->Option.getOr("")

  let onClick = _ => onClose()
  let onKeyDown = evt => {
    evt->Keyboard.stopPropagation
    if Keyboard.key(evt) == "Escape" {
      onClose()
    }
  }

  React.useEffect0(() => {
    ".modal-open form"->Utils.querySelectAndThen(Utils.focus)
    None
  })

  <div
    onContextMenu=Mouse.stopPropagation
    onWheel=Wheel.stopPropagation
    onClick
    onKeyDown
    className="modal modal-open modal-bottom sm:modal-middle">
    <div className onClick=Mouse.stopPropagation>
      <div className="flex flex-row items-center justify-between mb-4 -mt-1">
        <p className="font-bold text-lg"> {React.string(title)} </p>
        <button id="close-btn" onClick className="btn btn-sm btn-circle btn-ghost -mt-2">
          {React.string(`✕`)}
        </button>
      </div>
      {children}
    </div>
  </div>
}
