open Store
open Page
open Heroicons

@react.component
let make = (~page: option<Page.t>, ~setPageId, ~isEditing, ~isSearching, ~isSavedLinks) => {
  let store = Store.use()

  let pos = "-left-56 has-[#theme-btn:focus]:left-0 has-[#theme-container>*:focus]:left-0"

  let pagesBtns = Array.map(store.pages, p => {
    let key = Int.toString(p.id)
    let isActive = page->Option.map(activeP => activeP.id == p.id)->Option.getOr(false)
    <PageButton page=p key isActive setPageId isEditing />
  })

  <div className={`fixed top-0 ${pos} z-10 w-fit h-full flex flex-row transitional`}>
    <ul
      onWheel=ReactEvent.Wheel.stopPropagation
      id="theme-container"
      tabIndex=0
      className="flex flex-col gap-4 w-56 p-4 min-h-0 overflow-y-auto bg-secondary">
      <ThemesList />
    </ul>
    <div
      id="sidebar"
      className="w-12 xxl:w-20 p-1 xxl:p-2 flex flex-col gap-1 xxl:gap-2 h-full bg-base-100">
      <div
        onWheel=ReactEvent.Wheel.stopPropagation
        className="min-w-0 flex flex-col gap-1 xxl:gap-2 overflow-y-auto">
        {React.array(pagesBtns)}
      </div>
      {isEditing ? <AddPageButton /> : React.null}
      <div className="grow" />
      <button
        onClick={_ => setPageId(_ => Some(-2))}
        ariaLabel="saved-links-btn"
        className={`btn resp-btn sidebar-btn ${isSavedLinks ? "btn-primary" : "btn-ghost"}`}>
        <Solid.LinkIcon className="resp-icon" />
      </button>
      {store.options.useSearcher
        ? <button
            onClick={_ => setPageId(_ => Some(-1))}
            ariaLabel="searcher-btn"
            className={`btn resp-btn sidebar-btn ${isSearching ? "btn-primary" : "btn-ghost"}`}>
            <Solid.SearchIcon className="resp-icon" />
          </button>
        : React.null}
      <OptionsButton page />
      <button
        ariaLabel="select-theme-btn"
        id="theme-btn"
        className="btn btn-ghost resp-btn sidebar-btn w-full">
        <Solid.ColorSwatchIcon className="resp-icon" />
      </button>
    </div>
  </div>
}
