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
      | Some(page) => <PageCards page key=page.title isEditing />
      | None => React.null
      }}
    </div>
  </div>
}

// type point = {x: float, y: float}

// module Codecs = {
//   let point = Jzon.object2(
//     ({x, y}) => (x, y),
//     ((x, y)) => {x, y}->Ok,
//     Jzon.field("x", Jzon.float),
//     Jzon.field("y", Jzon.float),
//   )
// }

// let point = Dom.Storage2.getItem(Dom.Storage2.localStorage, "point")
// switch point {
// | None => Js.log("no point")
// | Some(val) => Js.log(val->Jzon.decodeStringWith(Codecs.point))
// }
