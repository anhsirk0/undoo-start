include Page
open Heroicons

module EditModal = {
  @react.component
  let make = (~page: Page.t, ~onClose) => {
    let onSubmit = evt => {
      JsxEvent.Form.preventDefault(evt)
      let title = ReactEvent.Form.target(evt)["title"]["value"]
      let icon = ReactEvent.Form.target(evt)["icon"]["value"]

      // openUrl("https://duckduckgo.com/?q=" ++ q, "_blank")
    }

    <div className="modal modal-open modal-bottom sm:modal-middle">
      <div className="modal-box flex flex-col max-h-[60vh]">
        <div className="flex flex-row items-center justify-between mb-4 -mt-1">
          <p className="font-bold text-lg"> {React.string(page.title)} </p>
          <button onClick=onClose className="btn btn-sm btn-circle btn-ghost -mt-2">
            {React.string(`✕`)}
          </button>
        </div>
        <form onSubmit className="flex flex-col gap-4">
          <Input name="title" defaultValue=page.title label="Title" />
          <Input name="icon" defaultValue=page.icon label="Icon" />
          <div className="flex flex-row gap-4 mt-4">
            <button type_="button" className="btn resp-btn btn-error">
              <Solid.TrashIcon className="resp-icon" />
            </button>
            <div className="grow" />
            <button className="btn resp-btn btn-success"> {React.string("Save changes")} </button>
          </div>
        </form>
      </div>
    </div>
  }
}

@react.component
let make = (~page: Page.t, ~isActive, ~isEditing, ~setActivePage) => {
  let (isOpen, setIsOpen) = React.useState(_ => false)

  let btnClass = isActive ? "btn-primary" : "btn-ghost"
  let ring = isOpen ? "ring" : ""
  let className = `btn sidebar-btn w-full center ${btnClass} text-4xl truncate relative resp-text ${ring}`

  let onClick = _ => setActivePage(_ => Some(page))
  let toggleOpen = evt => {
    JsxEvent.Mouse.stopPropagation(evt)
    setIsOpen(val => !val)
  }

  <React.Fragment>
    {isEditing
      ? <div role="button" className onClick>
          {React.string(page.icon)}
          <div
            className="bg-base-100/70 absolute bottom-0 right-0 size-3/5 xxl:size-1/2 center resp-text rounded-tl-box"
            onClick=toggleOpen>
            <Solid.PencilIcon className="resp-icon text-base-content" />
          </div>
        </div>
      : <button className onClick> {React.string(page.icon)} </button>}
    {isOpen ? <EditModal page onClose=toggleOpen /> : React.null}
  </React.Fragment>
}
