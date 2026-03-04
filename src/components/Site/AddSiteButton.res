@react.component
let make = (~addSite: Shape.Site.t => unit) => {
  let hideAddButton = Store.Options.useShallow(s => s.options.hideAddButton)

  let (isOpen, toggleOpen, _) = Hook.useToggle()

  <React.Fragment>
    <button
      ariaLabel="add-site-btn"
      id="add-btn"
      onClick={_ => toggleOpen()}
      className={hideAddButton
        ? "hidden"
        : "fixed bottom-2 right-2 btn btn-ghost resp-btn btn-circle animate-grow"}
    >
      <Icon.plus className="resp-icon" />
    </button>
    {isOpen ? <AddSiteModal site={None} onSubmit=addSite onClose=toggleOpen /> : React.null}
  </React.Fragment>
}
