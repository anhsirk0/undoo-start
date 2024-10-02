include Page
open Heroicons

@react.component
let make = (~activePage, ~setActivePage, ~isEditing, ~setIsEditing) => {
  let leftPos = "-left-56 has-[#theme-btn:focus]:left-0 has-[#theme-container>*:focus]:left-0"

  let pages = Array.map(Page.defaultPages, page => {
    let key = Int.toString(page.id)
    <PageButton page key isActive={activePage == page.id} setActivePage isEditing />
  })

  <React.Fragment>
    <div className={`fixed top-0 ${leftPos} z-10 w-fit h-full flex flex-row transitional`}>
      <ul
        id="theme-container"
        tabIndex={0}
        className="flex flex-col gap-4 w-56 p-4 min-h-0 overflow-y-auto bg-accent">
        <ThemesList />
      </ul>
      <div className="w-16 xxl:w-28 p-2 xxl:p-4 flex flex-col gap-2 xxl:gap-4 h-full bg-base-200">
        {React.array(pages)}
        <div className="grow" />
        <button
          onClick={_ => setIsEditing(val => !val)}
          className={`btn sidebar-btn ${isEditing ? "btn-accent" : "btn-ghost"}`}>
          <Solid.AdjustmentsIcon className="w-8 h-8" />
        </button>
        <button id="theme-btn" className="btn btn-ghost sidebar-btn w-full">
          <Solid.ColorSwatchIcon className="w-8 h-8" />
        </button>
      </div>
    </div>
  </React.Fragment>
}
