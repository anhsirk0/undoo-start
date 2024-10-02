include Store
open Heroicons

module DeleteButton = {
  @react.component
  let make = () => {
    <button type_="button" className="btn resp-btn btn-error">
      <Solid.TrashIcon className="resp-icon" />
    </button>
  }
}

@react.component
let make = (~page: Page.t, ~onClose) => {
  let store = Store.use()

  let onSubmit = evt => {
    JsxEvent.Form.preventDefault(evt)
    // let title = ReactEvent.Form.target(evt)["title"]["value"]
    // let icon = ReactEvent.Form.target(evt)["icon"]["value"]

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
          {Array.length(store.pages) != 1 ? <DeleteButton /> : React.null}
          <div className="grow" />
          <button className="btn resp-btn btn-success"> {React.string("Save changes")} </button>
        </div>
      </form>
    </div>
  </div>
}
