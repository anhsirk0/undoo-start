open Heroicons

@react.component
let make = () => {
  <div className="center h-[20vh] w-full p-4 ml-16">
    <label
      className="input input-primary xxl:input-lg flex items-center w-full max-w-3xl xxl:max-w-5xl">
      <input type_="text" className="grow " placeholder="Search" />
      <Solid.SearchIcon className="w-8 h-8" />
    </label>
  </div>
}
