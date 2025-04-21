open Heroicons

@react.component
let make = (~setImg, ~setImgName) => {
  let {options, removeImage} = Store.Bg.use()

  let onRemove = evt => {
    ReactEvent.Mouse.preventDefault(evt)
    removeImage()
  }

  let onChange = evt => {
    let files = ReactEvent.Form.target(evt)["files"]
    switch files[0] {
    | Some(file) => {
        let reader = FileReader.new()
        reader->FileReader.onload(s => {
          setImgName(_ => file["name"])
          setImg(_ => s)
        })
        reader->FileReader.readAsDataURL(file)
      }
    | None => ()
    }
  }

  <React.Fragment>
    <FormControl label="Image (max size: 3MB)">
      <div className="flex flex-row gap-4">
        <input
          type_="file" className="file-input 2xl:file-input-lg grow" accept="image/*" onChange
        />
        {options.image->String.length > 20
          ? <button
              type_="button" className="btn btn-outline btn-error max-w-[40%]" onClick=onRemove>
              <div className="flex flex-row gap-2 w-full items-center">
                <Solid.TrashIcon className="resp-icon" />
                <p className="truncate grow title"> {React.string(options.imageName)} </p>
              </div>
            </button>
          : React.null}
      </div>
    </FormControl>
    <FormControl label="Background opacity">
      <Range name="bg-opacity" defaultValue={options.bgOpacity->Int.toString} />
    </FormControl>
    // <FormControl label="Sidebar opacity">
    //   <Range name="sidebar-opacity" defaultValue={options.sidebarOpacity->Float.toString} />
    // </FormControl>
    <FormControl label="Searchbar opacity">
      <Range name="search-opacity" defaultValue={options.searchOpacity->Int.toString} />
    </FormControl>
    <FormControl label="Searcher items opacity">
      <Range name="searcher-opacity" defaultValue={options.searcherOpacity->Int.toString} />
    </FormControl>
    <div className="mt-4 flex flex-row gap-2 w-full items-center">
      <Solid.InformationCircleIcon className="resp-icon" />
      {React.string(
        "For better aesthetics, it is recommended to choose a theme matching your background image",
      )}
    </div>
    <div className="grow" />
    <div className="flex flex-row mt-4 justify-end">
      <button className="btn resp-btn btn-primary"> {React.string("Save")} </button>
    </div>
  </React.Fragment>
}
