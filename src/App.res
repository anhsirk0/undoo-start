include Page

@react.component
let make = () => {
  let (pages, setPages) = React.useState(_ => Page.defaultPages)
  let (page, setPage) = React.useState(_ => pages[0])
  let (isEditing, setIsEditing) = React.useState(_ => false)

  <div className="h-screen w-screen center flex-col p-16 transitional">
    <Sidebar page setPage pages isEditing setIsEditing />
    <SearchBar />
    <div
      className="grow w-full max-w-5xl xxl:max-w-screen-xxl ml-16 py-4 lg:py-8 xxl:py-16 min-h-0 overflow-y-auto">
      {switch page {
      | Some(p) => <PageCards sites=p.sites key=p.title isEditing />
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
