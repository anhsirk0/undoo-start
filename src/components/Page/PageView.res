open Heroicons
open ReactEvent

@react.component
let make = (~page: Shape.Page.t, ~afterDelete, ~isEditing, ~isVisiting) => {
  Hook.useDocTitle(Some(page.title))

  let (isOpen, toggleOpen, _) = Hook.useToggle()

  let onEdit = evt => {
    evt->ReactEvent.Mouse.stopPropagation
    toggleOpen()
  }

  let onWheel = evt => {
    let target = evt->Wheel.target
    if target["scrollHeight"] > target["clientHeight"] {
      evt->Wheel.stopPropagation
    }
  }

  <React.Fragment>
    <SearchBar />
    <div
      className="grow main-width xxl:max-w-7xl ml-12 p-4 lg:py-4 xxl:py-8 xxl:mt-12 min-h-0 overflow-y-auto"
      onWheel>
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
    </div>
  </React.Fragment>
}
