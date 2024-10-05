include Site
open Heroicons

@react.component
let make = (~addSite: Site.t => unit) => {
  let (isOpen, setIsOpen) = React.useState(_ => false)
  let toggleOpen = _ => setIsOpen(val => !val)

  let onSubmit = evt => {
    JsxEvent.Form.preventDefault(evt)
    let title = ReactEvent.Form.target(evt)["title"]["value"]
    let url = ReactEvent.Form.target(evt)["url"]["value"]
    let icon = ReactEvent.Form.target(evt)["icon"]["value"]
    let showLabel = ReactEvent.Form.target(evt)["label"]["checked"]

    addSite({
      title,
      url,
      icon,
      showLabel,
      id: Date.now()->Belt.Float.toInt,
    })
    toggleOpen()
  }

  <React.Fragment>
    <button
      onClick=toggleOpen
      className="fixed bottom-4 right-4 btn btn-neutral resp-btn btn-circle animate-grow">
      <Solid.PlusIcon className="resp-icon" />
    </button>
    {isOpen
      ? <Modal title="New Site" onClose=toggleOpen>
          <form onSubmit className="flex flex-col gap-4">
            <Input name="title" label="Title" required=true />
            <Input name="url" label="Url" required=true />
            <Input name="icon" label="Icon" required=true />
            <div className="form-control">
              <label className="label cursor-pointer">
                <span className="label-text"> {React.string("Show label")} </span>
                <input name="label" type_="checkbox" defaultChecked=true className="checkbox" />
              </label>
            </div>
            <div className="flex flex-row gap-4 mt-4">
              <div className="grow" />
              <button className="btn resp-btn btn-primary"> {React.string("Add Site")} </button>
            </div>
          </form>
        </Modal>
      : React.null}
  </React.Fragment>
}
