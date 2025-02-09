open Heroicons

@react.component
let make = () => {
  let store = Store.Options.use()
  let (isOpen, toggleOpen, _) = Hook.useToggle()

  let onSubmit = evt => {
    ReactEvent.Form.preventDefault(evt)
    let title = ReactEvent.Form.target(evt)["title"]["value"]

    store.addPage({
      title,
      id: Date.now(),
      sites: [],
    })
    toggleOpen()
  }

  <React.Fragment>
    <button
      ariaLabel="add-page-btn"
      onClick={_ => toggleOpen()}
      className={`btn btn-xs btn-square ${isOpen ? "btn-accent" : "btn-ghost"} mt-1`}>
      <Solid.PlusIcon className="size-6" />
    </button>
    {isOpen
      ? <Modal title="New Page" onClose=toggleOpen>
          <form onSubmit className="flex flex-col gap-2 xl:gap-4" tabIndex=0>
            <Input name="title" label="Title" required=true />
            <div className="flex flex-row gap-4 mt-4">
              <div className="grow" />
              <button className="btn resp-btn btn-primary"> {React.string("Add new Page")} </button>
            </div>
          </form>
        </Modal>
      : React.null}
  </React.Fragment>
}
