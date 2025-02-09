open Heroicons

@react.component
let make = (~page: option<Shape.Page.t>, ~setPageId, ~isEditing, ~isSearching, ~isSavedLinks) => {
  let (isOpen, toggleOpen, _) = Hook.useToggle()
  let {options} = Store.Options.use()

  let pos = "-left-56 has-[#theme-btn:focus]:left-0 has-[#theme-container>*:focus]:left-0"

  <div className={`fixed top-0 ${pos} z-10 w-fit h-full flex flex-row transitional`}>
    <ul
      onWheel=ReactEvent.Wheel.stopPropagation
      id="theme-container"
      tabIndex=0
      className="flex flex-col gap-4 w-56 p-4 min-h-0 overflow-y-auto bg-secondary">
      <ThemesList />
    </ul>
    <div className="p-1 flex flex-col gap-1 h-full">
      {!options.hidePageSwitcher ? <PageSwitcher page setPageId /> : React.null}
      {isEditing ? <AddPageButton /> : React.null}
      <div className="grow" />
      {!options.hideLinksButton
        ? <button
            onClick={_ => setPageId(_ => Some(-2.))}
            ariaLabel="saved-links-btn"
            className={`btn btn-xs btn-square ${isSavedLinks ? "btn-primary" : "btn-ghost"}`}>
            <Solid.LinkIcon className="resp-icon" />
          </button>
        : React.null}
      {!options.hideSearcherButton
        ? <button
            onClick={_ => setPageId(_ => Some(-1.))}
            ariaLabel="searcher-btn"
            className={`btn btn-xs btn-square ${isSearching ? "btn-primary" : "btn-ghost"}`}>
            <Solid.SearchIcon className="size-4" />
          </button>
        : React.null}
      <button
        ariaLabel="options-btn"
        id="options-btn"
        onClick={_ => toggleOpen()}
        className={`btn btn-xs btn-square ${isOpen
            ? "btn-accent"
            : "btn-ghost"} ${options.hideOptionsButton ? "opacity-0" : ""}`}>
        <Solid.AdjustmentsIcon className="size-4" />
      </button>
      <button
        ariaLabel="select-theme-btn"
        id="theme-btn"
        className={`btn btn-ghost btn-xs btn-square ${options.hideThemeButton ? "opacity-0" : ""}`}>
        <Solid.ColorSwatchIcon className="size-4" />
      </button>
    </div>
    {isOpen ? <Preferences onClose=toggleOpen /> : React.null}
  </div>
}
