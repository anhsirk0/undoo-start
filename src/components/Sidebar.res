@react.component
let make = () => {
  let (isPrefsOpen, togglePrefsOpen, _) = Hook.useToggle()
  let (isThemeOpen, toggleThemeOpen, _) = Hook.useToggle()

  let {options} = Store.Options.use()
  let {view, setView, isEditing} = Store.View.use()

  let opacity =
    isEditing || options.alwaysShowSidebar ? "opacity-100" : "opacity-0 hover:opacity-100"

  <div className={`fixed top-0 left-0 z-10 w-fit h-full flex flex-row transitional ${opacity}`}>
    <div className="p-1 flex flex-col gap-1 h-full">
      {!options.hidePageSwitcher ? <PageSwitcher /> : React.null}
      {isEditing ? <AddPageButton /> : React.null}
      <div className="grow" />
      {!options.hideSearcherButton
        ? <button
            onClick={_ => setView(Action(Searcher))}
            ariaLabel="searcher-btn"
            className={`btn btn-xs btn-square ${view == Action(Searcher)
                ? "btn-primary"
                : "btn-ghost"}`}>
            <Icon.magnifyingGlass className="size-5" />
          </button>
        : React.null}
      <button
        ariaLabel="options-btn"
        id="options-btn"
        onClick={_ => togglePrefsOpen()}
        className={`btn btn-xs btn-square ${isPrefsOpen
            ? "btn-accent"
            : "btn-ghost"} ${options.hideOptionsButton ? "opacity-0" : ""}`}>
        <Icon.gear className="size-5" />
      </button>
      <button
        ariaLabel="select-theme-btn"
        id="theme-btn"
        onClick={_ => toggleThemeOpen()}
        className={`btn btn-ghost btn-xs btn-square ${options.hideThemeButton ? "opacity-0" : ""}`}>
        <Icon.palette className="size-5" />
      </button>
    </div>
    {isPrefsOpen ? <Preferences onClose=togglePrefsOpen /> : React.null}
    <ThemeModal isOpen=isThemeOpen onClose=toggleThemeOpen />
  </div>
}
