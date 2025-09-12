@react.component
let make = (~view: Shape.View.t, ~setView) => {
  let store = Store.Options.use()

  let pagesBtns = Array.map(store.pages, p => {
    let btnClass = view == Page(p.id) ? "bg-base-content" : "bg-base-content/20"

    <button
      key={p.id->Float.toString}
      className={`btn btn-xs btn-circle center ${btnClass} no-animation`}
      onClick={_ => setView(_ => Shape.View.Page(p.id))}
    />
  })

  <div
    onWheel=ReactEvent.Wheel.stopPropagation
    className="min-w-0 flex flex-col gap-1 2xl:gap-2 overflow-y-auto">
    {React.array(pagesBtns)}
  </div>
}
