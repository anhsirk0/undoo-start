open Heroicons

@react.component
let make = (~page: option<Shape.Page.t>, ~setPageId, ~isEditing, ~isSearching, ~isSavedLinks) => {
  let (isOpen, toggleOpen, _) = Hook.useToggle()
  let store = Store.Options.use()

  let pos = "-left-56 has-[#theme-btn:focus]:left-0 has-[#theme-container>*:focus]:left-0"

  let pagesBtns = Array.map(store.pages, p => {
    let isActive = page->Option.map(activeP => activeP.id == p.id)->Option.getOr(false)
    let btnClass = isActive ? "btn-primary" : "btn-outline btn-primary"

    <button
      key={p.id->Float.toString}
      className={`btn btn-xs btn-square center ${btnClass} no-animation`}
      onClick={_ => setPageId(_ => Some(p.id))}
    />
  })

  <div className={`fixed top-0 ${pos} z-10 w-fit h-full flex flex-row transitional`}>
    <ul
      onWheel=ReactEvent.Wheel.stopPropagation
      id="theme-container"
      tabIndex=0
      className="flex flex-col gap-4 w-56 p-4 min-h-0 overflow-y-auto bg-secondary">
      <ThemesList />
    </ul>
    <div className="p-1 flex flex-col gap-1 h-full">
      <div
        onWheel=ReactEvent.Wheel.stopPropagation
        className="min-w-0 flex flex-col gap-1 xxl:gap-2 overflow-y-auto">
        {React.array(pagesBtns)}
      </div>
      {isEditing ? <AddPageButton /> : React.null}
      <div className="grow" />
      {store.options.useLinks
        ? <button
            onClick={_ => setPageId(_ => Some(-2.))}
            ariaLabel="saved-links-btn"
            className={`btn btn-xs btn-square ${isSavedLinks ? "btn-primary" : "btn-ghost"}`}>
            <Solid.LinkIcon className="resp-icon" />
          </button>
        : React.null}
      {store.options.useSearcher
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
        className={`btn btn-xs btn-square ${isOpen ? "btn-accent" : "btn-ghost"}`}>
        <Solid.AdjustmentsIcon className="size-4" />
      </button>
      <button
        ariaLabel="select-theme-btn" id="theme-btn" className="btn btn-ghost btn-xs btn-square">
        <Solid.ColorSwatchIcon className="size-4" />
      </button>
    </div>
    {isOpen ? <Preferences onClose=toggleOpen /> : React.null}
  </div>
}
