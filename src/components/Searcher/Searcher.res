include SearcherStore
include Utils

open Hooks
open Heroicons

@react.component
let make = () => {
  Hooks.useDocTitle(Some("Searcher"))

  let (value, setValue) = React.useState(_ => "")
  let onChange = evt => {
    let target = JsxEvent.Form.target(evt)
    let newValue: string = target["value"]
    setValue(_ => newValue)
  }

  let store = SearcherStore.use()
  let isAllChecked = store.engines->Array.every(e => store.checkedIds->Array.includes(e.id))
  let toggleAll = _ => store.toggleAll(isAllChecked)

  let onSubmit = evt => {
    JsxEvent.Form.preventDefault(evt)
    // let q = ReactEvent.Form.target(evt)["query"]["value"]

    store.engines
    ->Array.filter(e => store.checkedIds->Array.includes(e.id))
    ->Array.map(e => e.url->String.replace("<Q>", encodeURI(value)))
    ->Array.forEach(url => Utils.openUrl(url, "_blank"))
  }

  let onKeyDown = evt => {
    ReactEvent.Keyboard.stopPropagation(evt)
    if ReactEvent.Keyboard.key(evt) == "Escape" {
      evt->ReactEvent.Keyboard.target->Utils.blur
    }
  }

  let clearText = _ => {
    setValue(_ => "")
    switch ReactDOM.querySelector("input[name='query'") {
    | Some(el) => el->Utils.focus
    | None => ()
    }
  }

  let rows = store.engines->Array.map(item => {
    let checked = store.checkedIds->Array.includes(item.id)
    let toggleOne = _ => store.toggleOne(item.id, checked)
    let onDelete = _ => store.deleteEngine(item.id)

    <tr key={item.id->Int.toString}>
      <th>
        <Checkbox checked onChange=toggleOne />
      </th>
      <td className={checked ? "" : "opacity-60"}>
        <div className="font-bold"> {React.string(item.title)} </div>
      </td>
      <td className={checked ? "" : "opacity-60"}> {React.string(item.url)} </td>
      <th className="w-16">
        <EditSearcherButton engine=item />
      </th>
      <th className="w-16">
        <div className="dropdown dropdown-left dropdown-top">
          <label
            ariaLabel={`delete-${item.title}`}
            tabIndex=0
            className="btn text-error btn-ghost resp-btn">
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
    </tr>
  })

  <React.Fragment>
    <form onSubmit className="center h-[20vh] p-4 ml-12 join main-width">
      <label className="input input-primary xxl:input-lg flex items-center join-item grow">
        <input required=true onKeyDown name="query" className="grow" value onChange />
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
    <div className="center p-4 ml-12 join main-width">
      <div className="overflow-x-auto mb-20 lg:mb-0 bg-base-100 rounded-box w-full">
        <table className="table">
          <thead>
            <tr>
              <th>
                <Checkbox checked=isAllChecked onChange=toggleAll />
              </th>
              <th> {React.string("Title")} </th>
              <th> {React.string("URL")} </th>
              <th />
              <th />
            </tr>
          </thead>
          <tbody> {React.array(rows)} </tbody>
        </table>
      </div>
    </div>
    <AddSearcherButton />
  </React.Fragment>
}
