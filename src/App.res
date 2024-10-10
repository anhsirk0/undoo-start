include Store
include Utils
open Heroicons

@react.component
let make = () => {
  let store = Store.use()
  let (pageId, setPageId) = React.useState(_ => store.pages[0]->Option.map(p => p.id))
  let (isEditing, setIsEditing) = React.useState(_ => false)
  let (isDebounced, setIsDebounced) = React.useState(_ => true)

  let onContextMenu = evt => {
    setIsEditing(v => !v)
    JsxEvent.Mouse.preventDefault(evt)
  }

  let onWheel = evt => {
    if isDebounced {
      setIsDebounced(_ => false)

      let deltaY = ReactEvent.Wheel.deltaY(evt)->Float.toInt
      let nextPageId =
        pageId
        ->Option.map(id => store.pages->Array.findIndex(p => p.id == id))
        ->Option.map(index => index->Utils.getNextIndex(store.pages->Array.length, deltaY))
        ->Option.flatMap(index => store.pages[index])
        ->Option.map(p => p.id)

      setPageId(_ => nextPageId)

      let _ = setTimeout(_ => setIsDebounced(_ => true), 200)
    }
  }

  let page = pageId->Option.flatMap(id => store.pages->Array.find(p => p.id == id))

  <div onContextMenu onWheel className="h-screen w-screen center flex-col p-8 transitional">
    <button
      ariaLabel="toggle-edit-mode-btn"
      onClick={_ => setIsEditing(val => !val)}
      className={`fixed top-2 xxl:top-5 right-2 xxl:right-4 btn btn-circle btn-resp ${isEditing
          ? "btn-accent"
          : "btn-ghost"}`}>
      <Solid.PencilIcon className="resp-icon" />
    </button>
    <Sidebar page setPageId isEditing />
    <SearchBar />
    <div
      onWheel=ReactEvent.Wheel.stopPropagation
      className="grow w-full max-w-5xl xxl:max-w-screen-xxl ml-16 py-4 lg:py-4 xxl:py-8 min-h-0 overflow-y-auto">
      {switch page {
      | Some(page) => <SiteCards page key=page.title isEditing />
      | None => React.null
      }}
    </div>
  </div>
}
