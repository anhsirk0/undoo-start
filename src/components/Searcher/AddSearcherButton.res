@react.component
let make = () => {
  let hideAddButton = Store.Options.useShallow(s => s.options.hideAddButton)
  let addEngine = Store.Searcher.useShallow(s => s.addEngine)

  let (isOpen, toggleOpen, _) = Hook.useToggle()

  let onSubmit = evt => {
    ReactEvent.Form.preventDefault(evt)
    let title = ReactEvent.Form.target(evt)["title"]["value"]
    let url = ReactEvent.Form.target(evt)["url"]["value"]

    addEngine({title, url, icon: url, id: Date.now()})
    toggleOpen()
  }

  <React.Fragment>
    <button
      id="add-btn"
      ariaLabel="add-searcher-btn"
      onClick={_ => toggleOpen()}
      className={hideAddButton
        ? "hidden"
        : "fixed bottom-2 right-2 btn btn-ghost resp-btn btn-circle"}
    >
      <Icon.plus className="resp-icon" />
    </button>
    {isOpen
      ? <Modal title="New Searcher" onClose=toggleOpen>
          <SearcherForm onSubmit title="" url="" />
        </Modal>
      : React.null}
  </React.Fragment>
}
