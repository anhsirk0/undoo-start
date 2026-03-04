@react.component
let make = (~page: Shape.Page.t, ~onClose, ~afterDelete) => {
  let (pages, setPages, updatePage) = Store.Options.useShallow(s => (
    s.pages,
    s.setPages,
    s.updatePage,
  ))

  let onSubmit = evt => {
    ReactEvent.Form.preventDefault(evt)
    let title = ReactEvent.Form.target(evt)["title"]["value"]
    // let icon = ReactEvent.Form.target(evt)["icon"]["value"]

    updatePage({...page, title})
    onClose()
  }

  let onClick = _ => {
    let pages = pages->Array.filter(p => p.id != page.id)
    setPages(pages)
    afterDelete(pages)
  }

  <Modal title=page.title onClose>
    <form onSubmit className="flex flex-col gap-2 xl:gap-4" tabIndex=0>
      <Input name="title" defaultValue=page.title label="Title" />
      // <Input name="icon" defaultValue=page.icon label="Icon" />
      <div className="flex flex-row gap-4 mt-4">
        {pages->Array.length != 1
          ? <button
              ariaLabel="delete-page-btn" onClick type_="button" className="btn resp-btn btn-ghost"
            >
              <Icon.trash className="resp-icon text-error" />
            </button>
          : React.null}
        <div className="grow" />
        <button className="btn resp-btn btn-primary"> {React.string("Update page")} </button>
      </div>
    </form>
  </Modal>
}
