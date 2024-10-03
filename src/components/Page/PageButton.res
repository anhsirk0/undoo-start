include Store
open Heroicons

@react.component
let make = (~page: Page.t, ~isActive, ~isEditing, ~setActivePage) => {
  let store = Store.use()

  let (isOpen, setIsOpen) = React.useState(_ => false)

  let btnClass = isActive ? "btn-primary" : "btn-ghost"
  let ring = isOpen ? "ring" : ""
  let className = `btn sidebar-btn w-full center ${btnClass} text-4xl truncate relative resp-text ${ring}`

  let onClick = _ => setActivePage(_ => Some(page))

  let toggleOpen = (~evt=?) => {
    switch evt {
    | Some(e) => JsxEvent.Mouse.stopPropagation(e)
    | None => ()
    }
    setIsOpen(val => !val)
  }

  let afterDelete = _ => {
    if isActive {
      setActivePage(_ => store.pages[0])
    }
  }

  <React.Fragment>
    {isEditing
      ? <div role="button" className onClick>
          {React.string(page.icon)}
          <div
            className="bg-base-100/70 absolute bottom-0 right-0 size-3/5 xxl:size-1/2 center resp-text rounded-tl-box"
            onClick={evt => toggleOpen(~evt)}>
            <Solid.PencilIcon className="resp-icon text-base-content" />
          </div>
        </div>
      : <button className onClick> {React.string(page.icon)} </button>}
    {isOpen ? <EditPageModal page onClose={_ => toggleOpen()} afterDelete /> : React.null}
  </React.Fragment>
}
