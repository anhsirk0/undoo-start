include Site
// type point = {
//   x: float,
//   y: float,
// }

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

@react.component
let make = () => {
  Js.log(Site.defaultSites)

  let cards = Array.map(Site.defaultSites, site => {
    <div
      key={Int.toString(site.id)}
      className="col-span-6 sm:col-span-4 md:col-span-3 lg:col-span-2 xxl:col-span-2">
      <Card site />
    </div>
  })

  <div className="h-screen w-screen center flex-col p-16 transitional">
    <Sidebar />
    <SearchBar />
    <div className="center grow w-full max-w-5xl xxl:max-w-screen-xxl ml-16">
      <div className="grid grid-cols-12 gap-4 lg:gap-8 xl:gap-10 xxl:gap-12 w-full -mt-16">
        {React.array(cards)}
      </div>
    </div>
  </div>
}
