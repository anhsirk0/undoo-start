@react.component
let make = (~view: Shape.View.t, ~setView, ~isEditing) => {
  let (isPrefsOpen, togglePrefsOpen, _) = Hook.useToggle()
  let (isThemeOpen, toggleThemeOpen, _) = Hook.useToggle()
  let {options} = Store.Options.use()

  let opacity =
    isEditing || options.alwaysShowSidebar ? "opacity-100" : "opacity-0 hover:opacity-100"

  <div className={`fixed top-0 left-0 z-10 w-fit h-full flex flex-row transitional ${opacity}`}>
    <div className="p-1 flex flex-col gap-1 h-full">
      {!options.hidePageSwitcher ? <PageSwitcher view setView /> : React.null}
      {isEditing ? <AddPageButton /> : React.null}
      <div className="grow" />
      {!options.hideLinksButton
        ? <button
            onClick={_ => setView(_ => Shape.View.SavedLinks)}
            ariaLabel="saved-links-btn"
            className={`btn btn-xs btn-square ${view == SavedLinks ? "btn-primary" : "btn-ghost"}`}>
            <Icon.link className="resp-icon" />
          </button>
        : React.null}
      {!options.hideSearcherButton
        ? <button
            onClick={_ => setView(_ => Shape.View.Searcher)}
            ariaLabel="searcher-btn"
            className={`btn btn-xs btn-square ${view == Searcher ? "btn-primary" : "btn-ghost"}`}>
            <Icon.magnifyingGlass className="size-4" />
          </button>
        : React.null}
      <button
        ariaLabel="options-btn"
        id="options-btn"
        onClick={_ => togglePrefsOpen()}
        className={`btn btn-xs btn-square ${isPrefsOpen
            ? "btn-accent"
            : "btn-ghost"} ${options.hideOptionsButton ? "opacity-0" : ""}`}>
        <Icon.gear className="size-4" />
      </button>
      <button
        ariaLabel="select-theme-btn"
        id="theme-btn"
        onClick={_ => toggleThemeOpen()}
        className={`btn btn-ghost btn-xs btn-square ${options.hideThemeButton ? "opacity-0" : ""}`}>
        <Icon.palette className="size-4" />
      </button>
    </div>
    {isPrefsOpen ? <Preferences onClose=togglePrefsOpen /> : React.null}
    <ThemeModal isOpen=isThemeOpen onClose=toggleThemeOpen />
  </div>
}
