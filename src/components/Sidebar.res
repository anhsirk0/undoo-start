include Store
open Heroicons

@react.component
let make = (~page: option<Page.t>, ~setPage, ~isEditing, ~setIsEditing) => {
  let store = Store.use()

  let leftPos = "-left-56 has-[#theme-btn:focus]:left-0 has-[#theme-container>*:focus]:left-0"

  let pagesBtns = Array.map(store.pages, p => {
    let key = Int.toString(p.id)
    let isActive = page->Option.map(activeP => activeP.id == p.id)->Option.getOr(false)
    <PageButton page=p key isActive setActivePage=setPage isEditing />
  })

  <React.Fragment>
    <div className={`fixed top-0 ${leftPos} z-10 w-fit h-full flex flex-row transitional shadow`}>
      <ul
        id="theme-container"
        tabIndex=0
        className="flex flex-col gap-4 w-56 p-4 min-h-0 overflow-y-auto bg-accent">
        <ThemesList />
      </ul>
      <div className="w-16 xxl:w-28 p-2 xxl:p-4 flex flex-col gap-2 xxl:gap-4 h-full bg-base-200">
        {React.array(pagesBtns)}
        <div className="grow" />
        <button
          onClick={_ => setIsEditing(val => !val)}
          className={`btn sidebar-btn ${isEditing ? "btn-accent" : "btn-ghost"}`}>
          <Solid.PencilIcon className="resp-icon" />
        </button>
        <button id="theme-btn" className="btn btn-ghost sidebar-btn w-full">
          <Solid.ColorSwatchIcon className="resp-icon" />
        </button>
      </div>
    </div>
  </React.Fragment>
}
