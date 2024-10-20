include SearcherStore
open Heroicons

@react.component
let make = () => {
  let store = SearcherStore.use()

  let (isOpen, setIsOpen) = React.useState(_ => false)
  let toggleOpen = _ => setIsOpen(val => !val)

  let onSubmit = evt => {
    JsxEvent.Form.preventDefault(evt)
    let title = ReactEvent.Form.target(evt)["title"]["value"]
    let url = ReactEvent.Form.target(evt)["url"]["value"]

    store.addEngine({title, url, icon: url, id: Date.now()->Belt.Float.toInt})
    toggleOpen()
  }

  <React.Fragment>
    <button
      ariaLabel="add-searcher-btn"
      onClick=toggleOpen
      className="fixed bottom-2 xxl:bottom-5 right-2 xxl:right-4 btn btn-ghost resp-btn btn-circle">
      <Solid.PlusIcon className="resp-icon" />
    </button>
    {isOpen
      ? <Modal title="New Searcher" onClose=toggleOpen>
          <SearcherForm onSubmit title="" url="" />
        </Modal>
      : React.null}
  </React.Fragment>
}
