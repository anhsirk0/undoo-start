include Store
open Heroicons

@react.component
let make = (~page: option<Page.t>, ~setPageId, ~isEditing, ~isSearching) => {
  let store = Store.use()

  let leftPos = "-left-56 has-[#theme-btn:focus]:left-0 has-[#theme-container>*:focus]:left-0"

  let pagesBtns = Array.map(store.pages, p => {
    let key = Int.toString(p.id)
    let isActive = page->Option.map(activeP => activeP.id == p.id)->Option.getOr(false)
    <PageButton page=p key isActive setPageId isEditing />
  })

  <React.Fragment>
    <div className={`fixed top-0 ${leftPos} z-10 w-fit h-full flex flex-row transitional shadow`}>
      <ul
        onWheel=ReactEvent.Wheel.stopPropagation
        id="theme-container"
        tabIndex=0
        className="flex flex-col gap-4 w-56 p-4 min-h-0 overflow-y-auto bg-secondary">
        <ThemesList />
      </ul>
      <div className="w-16 xxl:w-28 p-2 xxl:p-4 flex flex-col gap-2 xxl:gap-4 h-full bg-base-100">
        <div
          onWheel=ReactEvent.Wheel.stopPropagation
          className="min-w-0 flex flex-col gap-2 xxl:gap-4 overflow-y-auto">
          {React.array(pagesBtns)}
        </div>
        {isEditing ? <AddPageButton /> : React.null}
        <div className="grow" />
        {store.useSearcher
          ? <button
              onClick={_ => setPageId(_ => Some(-1))}
              ariaLabel="searcher-btn"
              className={`btn sidebar-btn ${isSearching ? "btn-primary" : "btn-ghost"}`}>
              <Solid.SearchIcon className="resp-icon" />
            </button>
          : React.null}
        <OptionsButton page />
        <button
          ariaLabel="select-theme-btn" id="theme-btn" className="btn btn-ghost sidebar-btn w-full">
          <Solid.ColorSwatchIcon className="resp-icon" />
        </button>
      </div>
    </div>
  </React.Fragment>
}
