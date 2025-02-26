open Heroicons

@react.component
let make = (~engine: Shape.SearchEngine.t) => {
  let store = Store.Searcher.use()

  let (isOpen, toggleOpen, _) = Hook.useToggle()

  let onSubmit = evt => {
    ReactEvent.Form.preventDefault(evt)
    let title = ReactEvent.Form.target(evt)["title"]["value"]
    let url = ReactEvent.Form.target(evt)["url"]["value"]

    store.updateEngine({...engine, title, url})
    toggleOpen()
  }

  <React.Fragment>
    <button
      ariaLabel={`edit-${engine.title}`}
      onClick={_ => toggleOpen()}
      className="center p-2 bg-primary text-primary-content absolute top-0 left-0 rounded-br-box">
      <Solid.PencilIcon className="resp-icon" />
    </button>
    {isOpen
      ? <Modal title=engine.title onClose=toggleOpen>
          <SearcherForm onSubmit title=engine.title url=engine.url />
        </Modal>
      : React.null}
  </React.Fragment>
}
