open SearcherStore
open Utils
open Hooks
open Heroicons

@react.component
let make = (~isEditing) => {
  Hooks.useDocTitle(Some("Searcher"))

  let (value, setValue) = React.useState(_ => "")
  let onChange = evt => {
    let target = ReactEvent.Form.target(evt)
    let newValue: string = target["value"]
    setValue(_ => newValue)
  }

  let store = SearcherStore.use()
  let isAllChecked = store.engines->Array.every(e => store.checkedIds->Array.includes(e.id))
  let toggleAll = _ => store.toggleAll(isAllChecked)

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

  let rows = store.engines->Array.map(item => {
    let checked = store.checkedIds->Array.includes(item.id)
    let toggleOne = _ => store.toggleOne(item.id, checked)
    let onDelete = _ => store.deleteEngine(item.id)

    let onClick = _ => {
      if value->String.length > 0 {
        Utils.searchLink(item.url, value)
      }
    }

    <tr key={item.id->Int.toString}>
      <th>
        <Checkbox checked onChange=toggleOne />
      </th>
      <td className={checked ? "" : "opacity-60"}>
        <div className="font-bold"> {React.string(item.title)} </div>
      </td>
      <td className={checked ? "" : "opacity-60"}> {React.string(item.url)} </td>
      <td>
        <button ariaLabel={`search-${item.title}`} onClick className="btn btn-ghost btn-sm">
          <Solid.ExternalLinkIcon className="resp-icon" />
        </button>
      </td>
      {isEditing
        ? <React.Fragment>
            <th className="w-16">
              <EditSearcherButton engine=item />
            </th>
            <th className="w-16">
              <div className="dropdown dropdown-left dropdown-top">
                <label
                  ariaLabel={`delete-${item.title}`}
                  tabIndex=0
                  className="btn text-error btn-ghost btn-sm">
                  <Solid.TrashIcon className="resp-icon" />
                </label>
                <div
                  tabIndex=0
                  className="dropdown-content z-[1] card card-compact w-64 -mb-12 mr-2 px-2 py-1 shadow bg-base-200">
                  <div className="flex flex-row items-center justify-between gap-2 p-2">
                    <h3 className="text-xl"> {React.string("Are you sure?")} </h3>
                    <div className="flex flex-row gap-4 justify-end pt-2">
                      <button type_="button" className="btn btn-error resp-btn" onClick=onDelete>
                        {React.string("Delete")}
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </th>
          </React.Fragment>
        : React.null}
    </tr>
  })

  <React.Fragment>
    <form onSubmit className="center h-[20vh] p-4 ml-12 join main-width shrink-0 z-[5]">
      <label
        id="search" className="input input-primary xxl:input-lg flex items-center join-item grow">
        <InputBase required=true name="query" className="grow" value onChange />
        {value->String.length > 0
          ? <button
              onClick=clearText
              type_="button"
              className="btn btn-sm btn-ghost btn-circle text-base-content/60">
              <Solid.XIcon />
            </button>
          : React.null}
      </label>
      <button className="btn btn-primary xxl:btn-lg join-item no-animation">
        <Solid.SearchIcon className="resp-icon" />
      </button>
    </form>
    <div className="center px-4 xxl:py-4 ml-12 join main-width z-[5]">
      <div id="searchers" className="overflow-x-auto mb-16 lg:mb-0 bg-base-100 rounded-box w-full">
        <table className="table">
          <thead>
            <tr>
              <th>
                <Checkbox checked=isAllChecked onChange=toggleAll />
              </th>
              <th> {React.string("Title")} </th>
              <th> {React.string("URL")} </th>
              <th />
              {isEditing
                ? <React.Fragment>
                    <th />
                    <th />
                  </React.Fragment>
                : React.null}
            </tr>
          </thead>
          <tbody> {React.array(rows)} </tbody>
        </table>
      </div>
    </div>
    <AddSearcherButton />
  </React.Fragment>
}
