include Page
open Heroicons

@react.component
let make = (~activePage, ~setActivePage, ~isEditing, ~setIsEditing) => {
  let translateClasses = "-translate-x-56 has-[#theme-btn:focus]:translate-x-0 has-[#theme-container>*:focus]:translate-x-0"

  let pages = Array.map(Page.defaultPages, page => {
    let btnClass = activePage == page.id ? "btn-primary" : "btn-ghost"
    <button
      key={Int.toString(page.id)}
      className={`btn sidebar-btn w-full center ${btnClass} text-4xl truncate relative`}
      onClick={_ => setActivePage(_ => page.id)}>
      {React.string(page.icon)}
      {isEditing
        ? <div className="bg-base-100/70 absolute inset-0 size-full center">
            <Solid.PencilIcon className="w-10 h-10 text-base-content" />
          </div>
        : React.null}
    </button>
  })

  <div className={`fixed inset-0 w-fit h-full z-10 flex flex-row ${translateClasses} transitional`}>
    <ul
      id="theme-container"
      tabIndex={0}
      className="flex flex-col gap-4 w-56 p-4 min-h-0 overflow-y-auto bg-accent">
      <ThemesList />
    </ul>
    <div className="w-16 xxl:w-28 p-2 xxl:p-4 flex flex-col gap-2 xxl:gap-4 h-full bg-base-200">
      {React.array(pages)}
      <div className="grow" />
      {isEditing
        ? <div className="join join-vertical animate-grow">
            <button
              onClick={_ => setIsEditing(val => !val)}
              className="btn join-item btn-success sidebar-btn">
              <Solid.CheckIcon className="w-8 h-8" />
            </button>
            <button
              onClick={_ => setIsEditing(val => !val)}
              className="btn join-item btn-error sidebar-btn">
              <Solid.XIcon className="w-8 h-8" />
            </button>
          </div>
        : <button onClick={_ => setIsEditing(val => !val)} className="btn sidebar-btn btn-ghost">
            <Solid.AdjustmentsIcon className="w-8 h-8" />
          </button>}
      <button id="theme-btn" className="btn btn-ghost sidebar-btn w-full">
        <Solid.ColorSwatchIcon className="w-8 h-8" />
      </button>
    </div>
  </div>
}
