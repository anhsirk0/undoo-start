open Heroicons

@react.component
let make = (~page: Shape.Page.t, ~setPageId, ~isActive, ~isEditing) => {
  let store = Store.Options.use()

  let (isOpen, toggleOpen, _) = Hook.useToggle()

  let btnClass = isActive ? "btn-primary" : "btn-outline btn-primary"
  let ring = isOpen ? "ring" : ""
  let className = `btn btn-xs btn-square center ${btnClass} ${ring} no-animation`

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
    <button className onClick />
    {isEditing && isActive
      ? <div
          role="button"
          className="btn resp-btn absolute top-4 -right-36 z-20"
          ariaLabel={`edit-page-${page.id->Int.toString}-btn`}
          onClick=onEdit>
          <Solid.PencilIcon className="resp-icon text-base-content" />
          {"Edit page"->React.string}
        </div>
      : React.null}
    {isOpen ? <EditPageModal page onClose={_ => toggleOpen()} afterDelete /> : React.null}
  </React.Fragment>
}
