include Store
open Heroicons

@react.component
let make = () => {
  let store = Store.use()
  let (pageId, setPageId) = React.useState(_ => store.pages[0]->Option.map(p => p.id))
  let (isEditing, setIsEditing) = React.useState(_ => false)

  let page = pageId->Option.flatMap(id => store.pages->Array.find(p => p.id == id))

  let onContextMenu = evt => {
    setIsEditing(v => !v)
    JsxEvent.Mouse.preventDefault(evt)
  }

  <div onContextMenu className="h-screen w-screen center flex-col p-8 transitional">
    <button
      ariaLabel="toggle-edit-mode-btn"
      onClick={_ => setIsEditing(val => !val)}
      className={`fixed top-5 right-4 btn btn-circle ${isEditing ? "btn-accent" : "btn-ghost"}`}>
      <Solid.PencilIcon className="resp-icon" />
    </button>
    <Sidebar page setPageId isEditing />
    <SearchBar />
    <div
      className="grow w-full max-w-5xl xxl:max-w-screen-xxl ml-16 py-4 lg:py-4 xxl:py-8 min-h-0 overflow-y-auto">
      {switch page {
      | Some(page) => <SiteCards page key=page.title isEditing />
      | None => React.null
      }}
    </div>
  </div>
}
