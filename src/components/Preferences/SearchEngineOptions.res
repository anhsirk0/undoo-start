open Heroicons

module Item = {
  @react.component
  let make = (~item: Shape.SearchEngine.t, ~setNewEngines) => {
    let store = Store.SearchEngine.use()
    let onDelete = _ => {
      if store.engines->Array.some(Shape.SearchEngine.eq(item, _)) {
        store.deleteEngine(item.id)
      } else {
        setNewEngines(es => es->Array.filter(e => !Shape.SearchEngine.eq(item, e)))
      }
    }

    <form className="grid grid-cols-12 gap-2 border-t border-base-content/10 pt-2 px-1">
      <div className="col-span-8 lg:col-span-4">
        <Input name="title" label="Title" defaultValue=item.title required=true />
      </div>
      <div className="col-span-4 lg:col-span-1">
        <Input name="icon" label="Icon" defaultValue=item.icon required=true />
      </div>
      <div className="col-span-12 lg:col-span-7 flex items-end gap-2">
        <Input name="url" label="Url" defaultValue=item.url required=true />
        <div className="dropdown dropdown-end dropdown-left">
          <label
            ariaLabel={`delete-${item.title}`} tabIndex=0 className="btn btn-square btn-error mb-2">
            <Solid.TrashIcon className="resp-icon" />
          </label>
          <div
            tabIndex=0
            className="dropdown-content z-[1] card card-compact w-64 xl:w-72 -ml-6 px-2 py-1 shadow bg-error">
            <div className="flex flex-row items-center justify-between p-2">
              <h3 className="text-base xl:text-xl font-bold"> {"Are you sure?"->React.string} </h3>
              <button onClick=onDelete className="btn btn-neutral resp-btn">
                {"Yes, Delete"->React.string}
              </button>
            </div>
          </div>
        </div>
      </div>
    </form>
  }
}

@react.component
let make = () => {
  let (newEngines, setNewEngines) = React.useState(_ => [])

  let {engines, setEngines} = Store.SearchEngine.use()
  let allEngines = engines->Array.concat(newEngines)
  let onAdd = _ => setNewEngines(prev => prev->Array.concat([Shape.SearchEngine.make()]))
  let id = "search-engines-options"
  let onSave = _ => {
    let newEngines = Document.querySelectorAll(`#${id} > form`)->Array.mapWithIndex((el, idx) => {
      let fd = FormData.new(el)
      let title = fd->FormData.get("title")->Option.getOr("")
      let url = fd->FormData.get("url")->Option.getOr("")
      let icon = fd->FormData.get("icon")->Option.getOr("")

      let engine: Shape.SearchEngine.t = {id: idx->Int.toFloat +. Date.now(), title, icon, url}
      engine
    })

    if newEngines->Array.some(e => e.title == "" || e.url == "" || e.icon == "") {
      Toast.error("Some input fields are empty")
    } else {
      setNewEngines(_ => [])
      setEngines(newEngines)
      Toast.success("Search engines updated")
    }
  }

  <div className="flex flex-col 2xl:gap-2 [&>div]:min-w-[100%] min-h-[60vh] pt-2 2xl:pt-4">
    <div id className="flex flex-col gap-2 min-h-0 overflow-y-auto grow">
      {allEngines
      ->Array.map(item => <Item item key={item.id->Float.toString} setNewEngines />)
      ->React.array}
    </div>
    <div className="flex flex-row mt-4 gap-4 justify-between">
      <button onClick=onAdd className="btn resp-btn btn-neutral">
        <Solid.PlusIcon className="resp-icon" />
        {React.string("Add")}
      </button>
      <button onClick=onSave className="btn resp-btn btn-primary"> {React.string("Save")} </button>
    </div>
  </div>
}
