include Store

module Document = {
  type t
  @val external document: t = "document"
  @set external setTitle: (t, string) => unit = "title"
}

module UpdateTitleForm = {
  @react.component
  let make = () => {
    let store = Store.use()
    let onSubmit = evt => {
      JsxEvent.Form.preventDefault(evt)
      let newTitle = ReactEvent.Form.target(evt)["title"]["value"]
      store.updateTitle(newTitle)
    }

    <form
      onSubmit className="join animate-grow fixed bottom-4 left-16 md:left-[30vw] w-[40vw] z-10">
      <input
        name="title"
        defaultValue=store.title
        className="input input-accent join-item grow rounded-l-box"
        placeholder="Page title"
      />
      <button className="btn btn-accent join-item rounded-r-box">
        {React.string("Update page title")}
      </button>
    </form>
  }
}

@react.component
let make = (~page: option<Page.t>, ~isEditing) => {
  let store = Store.use()

  let title = switch page {
  | Some(p) => `${p.title} - ${store.title}`
  | None => store.title
  }

  React.useEffectOnEveryRender(() => {
    open! Document
    document->setTitle(title)
    None
  })

  isEditing ? <UpdateTitleForm /> : React.null
}
