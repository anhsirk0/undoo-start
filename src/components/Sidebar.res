open Heroicons

@react.component
let make = () => {
  let translateClasses = "-translate-x-56 has-[#theme-btn:focus]:translate-x-0 has-[#theme-container>*:focus]:translate-x-0"
  <div className={`fixed inset-0 w-fit h-full z-10 flex flex-row ${translateClasses} transitional`}>
    <ul
      id="theme-container"
      tabIndex={0}
      className="flex flex-col gap-4 w-56 p-4 min-h-0 overflow-y-auto bg-accent">
      <ThemesList />
    </ul>
    <div className="w-16 xxl:w-28 p-2 xxl:p-4 flex flex-col gap-2 xxl:gap-4 h-full bg-base-200">
      // <div className="h-12 rounded-box bg-accent w-full" />
      <div className="grow" />
      // <button className="btn sidebar-btn resp-btn btn-neutral">
      //   <Solid.AdjustmentsIcon className="w-8 h-8" />
      // </button>
      <button
        id="theme-btn" className="btn btn-neutral sidebar-btn resp-btn w-full focus:btn-accent">
        <Solid.ColorSwatchIcon className="w-8 h-8" />
      </button>
    </div>
  </div>
}
