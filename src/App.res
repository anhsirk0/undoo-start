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
  let cards = Array.map(Belt.Array.range(0, 11), i => {
    <div key={Int.toString(i)} className="col-span-3">
      <Card />
    </div>
  })

  <div className="h-screen w-screen center flex-col p-16 transition-all duration-400">
    <Sidebar />
    <SearchBar />
    <div className="center grow w-full max-w-5xl xxl:max-w-7xl">
      <div className="grid grid-cols-12 gap-8 w-full"> {React.array(cards)} </div>
    </div>
  </div>
}
