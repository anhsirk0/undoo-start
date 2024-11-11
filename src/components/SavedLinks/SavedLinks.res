open Fetch
open Utils
open LinkStore
open Heroicons

@react.component
let make = () => {
  let {links, addLink} = LinkStore.use()
  let (loading, setLoading) = React.useState(_ => false)
  let (value, setValue) = React.useState(_ => "")
  let onChange = evt => {
    let target = JsxEvent.Form.target(evt)
    let newValue: string = target["value"]
    setValue(_ => newValue)
  }

  let clearText = _ => {
    setValue(_ => "")
    "input[name='query']"->Utils.querySelectAndThen(Utils.focus)
  }

  let onSave = async () => {
    setLoading(_ => true)
    let title = await Fetch.getTitle(value)
    addLink({
      id: Date.now()->Float.toInt,
      title,
      url: value,
    })
    setLoading(_ => false)
    setValue(_ => "")
  }

  let onSubmit = evt => {
    JsxEvent.Form.preventDefault(evt)
    let _ = onSave()
  }

  let linkItems = links->Array.map(link => {
    <div key={link.id->Int.toString} className="col-span-3"> {link.title->React.string} </div>
  })

  <React.Fragment>
    <div className="center px-4 xxl:py-4 ml-12 main-width xxl:max-w-7xl z-[5]">
      <div className="grid grid-cols-12 gap-4 lg:gap-6 xxl:gap-8 w-full">
        <form onSubmit className="col-span-4 join">
          <label id="search" className="input input-primary flex items-center join-item grow">
            <InputBase
              required=true name="query" className="grow" value onChange placeholder="url"
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
          <button className="btn btn-primary no-animation join-item">
            <Solid.SearchIcon className="resp-icon" />
          </button>
        </form>
        {linkItems->React.array}
      </div>
    </div>
  </React.Fragment>
}
