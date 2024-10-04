include Store

@react.component
let make = () => {
  let store = Store.use()
  let (pageId, setPageId) = React.useState(_ => store.pages[0]->Option.map(p => p.id))
  let (isEditing, setIsEditing) = React.useState(_ => false)

  let page = pageId->Option.flatMap(id => store.pages->Array.find(p => p.id == id))

  <div className="h-screen w-screen center flex-col p-16 transitional">
    <Sidebar page setPageId isEditing setIsEditing />
    <SearchBar />
    <div
      className="grow w-full max-w-5xl xxl:max-w-screen-xxl ml-16 py-4 lg:py-8 xxl:py-16 min-h-0 overflow-y-auto">
      {switch page {
      | Some(page) => <SiteCards page key=page.title isEditing />
      | None => React.null
      }}
    </div>
  </div>
}
