open Heroicons

@react.component
let make = (~page: Shape.Page.t, ~setPageId, ~isEditing, ~isVisiting) => {
  Hook.useDocTitle(Some(page.title))
  let store = Store.Options.use()

  let (isOpen, toggleOpen, _) = Hook.useToggle()

  let onEdit = evt => {
    evt->ReactEvent.Mouse.stopPropagation
    toggleOpen()
  }

  let afterDelete = _ => {
    setPageId(_ => store.pages[0]->Option.map(p => p.id))
  }

  <React.Fragment>
    {isEditing
      ? <div
          role="button"
          className="btn resp-btn fixed top-4 left-12 z-20"
          ariaLabel={`edit-page-${page.id->Float.toString}-btn`}
          onClick=onEdit>
          <Solid.PencilIcon className="resp-icon text-base-content" />
          {"Edit page"->React.string}
        </div>
      : React.null}
    <SiteCards page isEditing isVisiting />
    {isOpen ? <EditPageModal page onClose={_ => toggleOpen()} afterDelete /> : React.null}
  </React.Fragment>
}
