@react.component
let make = (~addSite: Shape.Site.t => unit) => {
  let store = Store.Options.use()

  let (isOpen, toggleOpen, _) = Hook.useToggle()

  <React.Fragment>
    <button
      ariaLabel="add-site-btn"
      id="add-btn"
      onClick={_ => toggleOpen()}
      className={store.options.hideAddButton
        ? "hidden"
        : "fixed bottom-2 right-2 btn btn-ghost resp-btn btn-circle animate-grow"}>
      <Icon.plus className="resp-icon" />
    </button>
    {isOpen ? <AddSiteModal site={None} onSubmit=addSite onClose=toggleOpen /> : React.null}
  </React.Fragment>
}
