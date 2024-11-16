open Heroicons

@react.component
let make = (~page: Shape.Page.t, ~setPageId, ~isActive, ~isEditing) => {
  let store = Store.Options.use()

  let (isOpen, toggleOpen, _) = Hook.useToggle()

  let btnClass = isActive ? "btn-primary" : "btn-ghost"
  let ring = isOpen ? "ring" : ""
  let className = `btn resp-btn sidebar-btn w-full center ${btnClass} truncate relative xxl:text-4xl ${ring} no-animation`

  let onClick = _ => setPageId(_ => Some(page.id))

  let onEdit = evt => {
    evt->ReactEvent.Mouse.stopPropagation
    toggleOpen()
  }

  let afterDelete = _ => {
    if isActive {
      setPageId(_ => store.pages[0]->Option.map(p => p.id))
    }
  }

  <React.Fragment>
    {isEditing
      ? <div role="button" className onClick>
          {React.string(page.icon)}
          <div
            role="button"
            ariaLabel={`edit-page-${page.id->Int.toString}-btn`}
            className="bg-base-100/70 absolute top-0 right-0 size-3/5 xxl:size-1/2 center rounded-bl-box"
            onClick=onEdit>
            <Solid.PencilIcon className="resp-icon text-base-content" />
          </div>
        </div>
      : <button className onClick> {React.string(page.icon)} </button>}
    {isOpen ? <EditPageModal page onClose={_ => toggleOpen()} afterDelete /> : React.null}
  </React.Fragment>
}
