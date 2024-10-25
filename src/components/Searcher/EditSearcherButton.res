open SearcherStore
open Heroicons
open SearchEngine

@react.component
let make = (~engine: SearchEngine.t) => {
  let store = SearcherStore.use()

  let (isOpen, setIsOpen) = React.useState(_ => false)
  let toggleOpen = _ => setIsOpen(val => !val)

  let onSubmit = evt => {
    JsxEvent.Form.preventDefault(evt)
    let title = ReactEvent.Form.target(evt)["title"]["value"]
    let url = ReactEvent.Form.target(evt)["url"]["value"]

    store.updateEngine({...engine, title, url})
    toggleOpen()
  }

  <React.Fragment>
    <button
      ariaLabel={`edit-${engine.title}`} onClick=toggleOpen className="btn btn-ghost resp-btn">
      <Solid.PencilIcon className="resp-icon" />
    </button>
    {isOpen
      ? <Modal title=engine.title onClose=toggleOpen>
          <SearcherForm onSubmit title=engine.title url=engine.url />
        </Modal>
      : React.null}
  </React.Fragment>
}
