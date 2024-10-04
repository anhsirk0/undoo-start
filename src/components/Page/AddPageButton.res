include Store
open Heroicons

@react.component
let make = () => {
  let store = Store.use()

  let (isOpen, setIsOpen) = React.useState(_ => false)
  let toggleOpen = _ => setIsOpen(val => !val)

  let onSubmit = evt => {
    JsxEvent.Form.preventDefault(evt)
    let title = ReactEvent.Form.target(evt)["title"]["value"]
    let icon = ReactEvent.Form.target(evt)["icon"]["value"]

    store.addPage({
      title,
      icon,
      id: Date.now()->Belt.Float.toInt,
      sites: [],
    })
    toggleOpen()
  }

  <React.Fragment>
    <button
      onClick=toggleOpen
      className={`btn animate-grow sidebar-btn ${isOpen ? "btn-accent" : "btn-ghost"}`}>
      <Solid.PlusIcon className="resp-icon" />
    </button>
    {isOpen
      ? <Modal title="New Page" onClose=toggleOpen>
          <form onSubmit className="flex flex-col gap-4">
            <Input name="title" label="Title" required=true />
            <Input name="icon" label="Icon" required=true />
            <div className="flex flex-row gap-4 mt-4">
              <div className="grow" />
              <button className="btn resp-btn btn-success"> {React.string("Add new Page")} </button>
            </div>
          </form>
        </Modal>
      : React.null}
  </React.Fragment>
}