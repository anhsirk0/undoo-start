open Heroicons

@react.component
let make = () => {
  let {options, removeImage, update} = Store.Bg.use()
  let (img, setImg) = React.useState(_ => "")
  let (imgName, setImgName) = React.useState(_ => "")

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

  let onSubmit = evt => {
    let target = evt->ReactEvent.Form.target

    let bgOpacity = target["bg-opacity"]["value"]
    let searcherOpacity = target["searcher-opacity"]["value"]
    let searchOpacity = target["search-opacity"]["value"]
    // let sidebarOpacity = target["sidebar-opacity"]["value"]

    let imgExists = img->String.length > 20
    let image = imgExists ? img : options.image
    let imageName = imgExists ? imgName : options.imageName
    update({
      image,
      imageName,
      bgOpacity,
      searchOpacity,
      searcherOpacity,
      // sidebarOpacity,
    })
  }
  <form
    onSubmit
    className="flex flex-col 2xl:gap-2 [&>div]:min-w-[100%] min-h-[60vh] pt-2 2xl:pt-4"
    tabIndex=0>
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
                <p className="truncate grow title"> {options.imageName->React.string} </p>
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
      <button className="btn resp-btn btn-primary"> {"Save"->React.string} </button>
    </div>
  </form>
}
