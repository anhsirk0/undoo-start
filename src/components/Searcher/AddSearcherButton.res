open SearcherStore
open Store
open Heroicons
open Hooks

@react.component
let make = () => {
  let store = Store.use()
  let searcherStore = SearcherStore.use()

  let (isOpen, toggleOpen, _) = Hooks.useToggle()

  let onSubmit = evt => {
    ReactEvent.Form.preventDefault(evt)
    let title = ReactEvent.Form.target(evt)["title"]["value"]
    let url = ReactEvent.Form.target(evt)["url"]["value"]

    searcherStore.addEngine({title, url, icon: url, id: Date.now()->Float.toInt})
    toggleOpen()
  }

  <React.Fragment>
    <button
      id="add-btn"
      ariaLabel="add-searcher-btn"
      onClick={_ => toggleOpen()}
      className={store.options.hideAddButton
        ? "hidden"
        : "fixed bottom-2 xxl:bottom-5 right-2 xxl:right-4 btn btn-ghost resp-btn btn-circle"}>
      <Solid.PlusIcon className="resp-icon" />
    </button>
    {isOpen
      ? <Modal title="New Searcher" onClose=toggleOpen>
          <SearcherForm onSubmit title="" url="" />
        </Modal>
      : React.null}
  </React.Fragment>
}
