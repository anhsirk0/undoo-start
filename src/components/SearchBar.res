open Heroicons

@react.component
let make = () => {
  <div className="center h-[30vh] w-full p-4">
    <label
      className="input xxl:input-lg flex items-center w-full max-w-3xl xxl:max-w-5xl bg-primary/10">
      <input type_="text" className="grow" placeholder="Search" />
      <Solid.SearchIcon className="w-8 h-8" />
    </label>
  </div>
}
