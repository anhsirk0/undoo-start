include Store
open Heroicons

module DeleteButton = {
  @react.component
  let make = (~id, ~afterDelete) => {
    let store = Store.use()

    let onClick = _ => {
      store.deletePage(id)
      afterDelete()
    }

    <button onClick type_="button" className="btn resp-btn btn-error">
      <Solid.TrashIcon className="resp-icon" />
    </button>
  }
}

@react.component
let make = (~page: option<Page.t>, ~onClose, ~afterDelete) => {
  let store = Store.use()

  let pageTitle = page->Option.map(p => p.title)->Option.getOr("New Page")
  let pageIcon = page->Option.map(p => p.icon)->Option.getOr(`🏛`)

  let onSubmit = evt => {
    JsxEvent.Form.preventDefault(evt)
    // let title = ReactEvent.Form.target(evt)["title"]["value"]
    // let icon = ReactEvent.Form.target(evt)["icon"]["value"]

    // openUrl("https://duckduckgo.com/?q=" ++ q, "_blank")
  }

  <div className="modal modal-open modal-bottom sm:modal-middle">
    <div className="modal-box flex flex-col max-h-[60vh]">
      <div className="flex flex-row items-center justify-between mb-4 -mt-1">
        <p className="font-bold text-lg"> {React.string(pageTitle)} </p>
        <button onClick=onClose className="btn btn-sm btn-circle btn-ghost -mt-2">
          {React.string(`✕`)}
        </button>
      </div>
      <form onSubmit className="flex flex-col gap-4">
        <Input name="title" defaultValue=pageTitle label="Title" />
        <Input name="icon" defaultValue=pageIcon label="Icon" />
        <div className="flex flex-row gap-4 mt-4">
          {switch page {
          | Some(page) =>
            Array.length(store.pages) != 1 ? <DeleteButton id=page.id afterDelete /> : React.null
          | None => React.null
          }}
          <div className="grow" />
          <button className="btn resp-btn btn-success"> {React.string("Save changes")} </button>
        </div>
      </form>
    </div>
  </div>
}
