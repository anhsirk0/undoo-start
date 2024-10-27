open FileReader
open BgStore
open Heroicons

module Range = {
  @Jsx.element
  let make = props =>
    <input {...props} type_="range" min="0" max="100" className="range range-primary" />
}

@react.component
let make = (~setImg, ~setImgName) => {
  let {options, removeImage} = BgStore.use()

  let onRemove = _ => removeImage()

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
    <FormControl label="Image">
      <div className="flex flex-row gap-4">
        <InputBase
          type_="file" className="file-input file-input-bordered grow" accept="image/*" onChange
        />
        {options.image->String.length > 20
          ? <button
              type_="button" className="btn btn-outline btn-error max-w-[40%]" onClick=onRemove>
              <div className="flex flex-row gap-2 w-full items-center">
                <Solid.TrashIcon className="resp-icon" />
                <p className="truncate grow"> {React.string(options.imageName)} </p>
              </div>
            </button>
          : React.null}
      </div>
    </FormControl>
    <FormControl label="Background opacity">
      <Range name="bg-opacity" defaultValue={options.bgOpacity->Int.toString} />
    </FormControl>
    <FormControl label="Sidebar opacity">
      <Range name="sidebar-opacity" defaultValue={options.sidebarOpacity->Int.toString} />
    </FormControl>
    <FormControl label="Searchbar opacity">
      <Range name="search-opacity" defaultValue={options.searchOpacity->Int.toString} />
    </FormControl>
    <FormControl label="Searcher Table opacity">
      <Range name="searcher-opacity" defaultValue={options.searcherOpacity->Int.toString} />
    </FormControl>
  </React.Fragment>
}
