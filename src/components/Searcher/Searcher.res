open Heroicons

@react.component
let make = (~isEditing) => {
  Hook.useDocTitle(Some("Searcher"))

  let (value, setValue) = React.useState(_ => "")
  let onChange = evt => {
    let target = ReactEvent.Form.target(evt)
    let newValue: string = target["value"]
    setValue(_ => newValue)
  }

  let store = Store.Searcher.use()
  let isAllChecked = store.engines->Array.every(e => store.checkedIds->Array.includes(e.id))
  let toggleAll = _ => store.toggleAll(isAllChecked)
  let count = store.engines->Array.filter(e => store.checkedIds->Array.includes(e.id))->Array.length

  let onSubmit = evt => {
    ReactEvent.Form.preventDefault(evt)
    // let q = ReactEvent.Form.target(evt)["query"]["value"]

    store.engines
    ->Array.filter(e => store.checkedIds->Array.includes(e.id))
    ->Array.forEach(e => Utils.searchLink(e.url, value))
  }

  let clearText = _ => {
    setValue(_ => "")
    "input[name='query']"->Utils.querySelectAndThen(Utils.focus)
  }

  let items = store.engines->Array.map(item => {
    let checked = store.checkedIds->Array.includes(item.id)
    let toggleOne = _ => store.toggleOne(item.id, checked)
    let onDelete = _ => store.deleteEngine(item.id)

    let onClick = evt => {
      evt->ReactEvent.Mouse.stopPropagation
      if value->String.length > 0 {
        Utils.searchLink(item.url, value)
      }
    }

    let opacity = checked ? "bg-primary/20" : "opacity-80"

    <div
      key={item.id->Int.toString}
      className="col-span-6 md:col-span-4 animate-fade rounded-box relative overflow-hidden bg-base-300"
      name="searcher-item">
      <div
        onClick=toggleOne className={`flex flex-col gap-4 p-4 xxl:p-6 ${opacity} cursor-pointer`}>
        <p className="card-title"> {item.title->React.string} </p>
        <p className="text-base-content/60 title">
          {item.url->String.replace("https://", "")->React.string}
        </p>
        <button
          ariaLabel={`search-${item.title}`}
          onClick
          className="center p-2 bg-primary text-primary-content absolute right-0 bottom-0 rounded-tl-box">
          <Solid.ExternalLinkIcon className="resp-icon" />
        </button>
      </div>
      {isEditing ? <EditSearcherButton engine=item /> : React.null}
      {isEditing
        ? <div
            className="center absolute left-0 bottom-0 bg-error text-error-content rounded-tr-box p-1">
            <div className="dropdown dropdown-end dropdown-right">
              <label ariaLabel={`delete-${item.title}`} tabIndex=0>
                <Solid.TrashIcon className="resp-icon" />
              </label>
              <div
                tabIndex=0
                className="dropdown-content z-[1] card card-compact w-64 xl:w-72 -ml-6 px-2 py-1 shadow bg-error">
                <div className="flex flex-row items-center justify-between p-2">
                  <h3 className="text-base xl:text-xl font-bold">
                    {"Are you sure?"->React.string}
                  </h3>
                  <button type_="button" className="btn btn-neutral resp-btn" onClick=onDelete>
                    {"Yes, Delete"->React.string}
                  </button>
                </div>
              </div>
            </div>
          </div>
        : React.null}
    </div>
  })

  <React.Fragment>
    <form
      onSubmit
      className="center h-[20vh] p-4 ml-12 w-full max-w-xl xl:wax-w-4xl xxl:max-w-5xl shrink-0 z-[5]">
      <div id="searcher" className="center size-12 xxl:size-16 w-16 rounded-l-btn bg-base-300">
        <Checkbox checked=isAllChecked onChange=toggleAll />
        {count > 0
          ? <p className="text-lg text-primary"> {count->Int.toString->React.string} </p>
          : React.null}
      </div>
      <label
        id="search-input"
        className="input has-[:focus]:border-none has-[:focus]:outline-none bg-base-300 xxl:input-lg flex items-center join-item grow rounded-none">
        <InputBase
          required=true name="query" className="grow" value onChange placeholder="Search"
        />
        {value->String.length > 0
          ? <button
              onClick=clearText
              type_="button"
              className="btn btn-sm btn-ghost btn-circle text-base-content/60">
              <Solid.XIcon />
            </button>
          : React.null}
      </label>
      <button
        id="search-btn"
        className="btn btn-ghost bg-base-300 xxl:btn-lg join-item no-animation rounded-l-none">
        <Solid.SearchIcon className="resp-icon" />
      </button>
    </form>
    <div className="center px-4 xxl:py-4 ml-12 join main-width xxl:max-w-7xl z-[5]">
      <div className="grid grid-cols-12 gap-4 xl:gap-8 w-full"> {React.array(items)} </div>
      <AddSearcherButton />
    </div>
  </React.Fragment>
}
