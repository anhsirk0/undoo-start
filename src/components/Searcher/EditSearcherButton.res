open SearcherStore
open Heroicons
open SearchEngine
open Hooks

@react.component
let make = (~engine: SearchEngine.t) => {
  let store = SearcherStore.use()

  let (isOpen, toggleOpen, _) = Hooks.useToggle()

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
      className="btn btn-ghost btn-sm">
      <Solid.PencilIcon className="resp-icon" />
    </button>
    {isOpen
      ? <Modal title=engine.title onClose=toggleOpen>
          <SearcherForm onSubmit title=engine.title url=engine.url />
        </Modal>
      : React.null}
  </React.Fragment>
}
