open Heroicons

module DeleteButton = {
  @react.component
  let make = (~id, ~afterDelete) => {
    let store = Store.Options.use()

    let onClick = _ => {
      store.deletePage(id)
      afterDelete()
    }

    <button ariaLabel="delete-page-btn" onClick type_="button" className="btn resp-btn btn-ghost">
      <Solid.TrashIcon className="resp-icon text-error" />
    </button>
  }
}

@react.component
let make = (~page: Shape.Page.t, ~onClose, ~afterDelete) => {
  let store = Store.Options.use()

  let onSubmit = evt => {
    ReactEvent.Form.preventDefault(evt)
    let title = ReactEvent.Form.target(evt)["title"]["value"]
    let icon = ReactEvent.Form.target(evt)["icon"]["value"]

    store.updatePage({...page, title, icon})
    onClose()
  }

  <Modal title=page.title onClose>
    <form onSubmit className="flex flex-col gap-2 xl:gap-4" tabIndex=0>
      <Input name="title" defaultValue=page.title label="Title" />
      <Input name="icon" defaultValue=page.icon label="Icon" />
      <div className="flex flex-row gap-4 mt-4">
        {Array.length(store.pages) != 1 ? <DeleteButton id=page.id afterDelete /> : React.null}
        <div className="grow" />
        <button className="btn resp-btn btn-primary"> {React.string("Update page")} </button>
      </div>
    </form>
  </Modal>
}
