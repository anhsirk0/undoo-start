@react.component
let make = (~page: option<Shape.Page.t>, ~setPageId) => {
  let store = Store.Options.use()

  let pagesBtns = Array.map(store.pages, p => {
    let isActive = page->Option.map(activeP => activeP.id == p.id)->Option.getOr(false)
    let btnClass = isActive ? "btn-primary" : "btn-outline btn-primary"

    <button
      key={p.id->Float.toString}
      className={`btn btn-xs btn-square center ${btnClass} no-animation`}
      onClick={_ => setPageId(_ => Some(p.id))}
    />
  })

  <div
    onWheel=ReactEvent.Wheel.stopPropagation
    className="min-w-0 flex flex-col gap-1 xxl:gap-2 overflow-y-auto">
    {React.array(pagesBtns)}
  </div>
}
