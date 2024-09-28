open Heroicons

@react.component
let make = () => {
  <div className="fixed inset-0 w-28 p-4 h-full bg-primary/10 flex flex-col gap-4 z-10">
    <div className="h-16 rounded-box bg-accent max-w-5xl w-full" />
    <div className="grow" />
    <button className="btn h-20">
      <Solid.AdjustmentsIcon className="w-8 h-8" />
    </button>
    <SelectTheme/>
  </div>
}
