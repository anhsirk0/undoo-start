@react.component
let make = () => {
  let hideEditButton = Store.Options.useShallow(s => s.options.hideEditButton)
  let (view, isEditing, toggleEditing) = Store.View.useShallow(s => (
    s.view,
    s.isEditing,
    s.toggleEditing,
  ))

  hideEditButton || view == Action(Bookmarks)
    ? React.null
    : <button
        ariaLabel="toggle-edit-mode-btn"
        onClick={_ => toggleEditing()}
        className={`fixed top-2 right-2 btn btn-circle btn-resp ${isEditing
            ? "btn-accent"
            : "btn-ghost"}`}
      >
        <Icon.pencil className="resp-icon" />
      </button>
}
