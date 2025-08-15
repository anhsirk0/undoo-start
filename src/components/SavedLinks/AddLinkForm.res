@react.component
let make = (~link: option<Shape.Link.t>=?) => {
  let {addLink, updateLink} = Store.Link.use()
  let (loading, setLoading) = React.useState(_ => false)
  let (value, setValue) = React.useState(_ => link->Option.map(l => l.url)->Option.getOr(""))
  let onChange = evt => {
    let target = ReactEvent.Form.target(evt)
    let newValue: string = target["value"]
    setValue(_ => newValue)
  }

  let name = link->Option.map(l => l.id->Float.toString ++ "-url")->Option.getOr("url")
  let clearText = _ => {
    setValue(_ => "")
    `input[name='${name}']`->Utils.querySelectAndThen(Utils.focus)
  }

  let onSave = async () => {
    setLoading(_ => true)
    let title = await Fetch.getTitle(value)
    let id = link->Option.map(l => l.id)->Option.getOr(Date.now())
    let fn = link->Option.isSome ? updateLink : addLink
    fn({
      id,
      title,
      url: value,
    })
    setLoading(_ => false)
    setValue(_ => "")
  }

  let onSubmit = evt => {
    evt->ReactEvent.Form.preventDefault
    let _ = onSave()
  }

  <form onSubmit className="col-span-12 md:col-span-6 lg:col-span-4 join">
    <label
      id="search"
      className="input input-primary input-sm 2xl:input-md flex items-center join-item grow">
      <InputBase
        required=true name className="grow" value onChange placeholder="Add url" disabled=loading
      />
      {value->String.length > 0
        ? <button
            disabled=loading
            onClick=clearText
            type_="button"
            className="btn btn-xs 2xl:btn-sm btn-ghost btn-circle text-base-content/60">
            <Icon.x />
          </button>
        : React.null}
    </label>
    <button disabled=loading className="btn btn-primary btn-sm 2xl:btn-md no-animation join-item">
      {loading
        ? <span className="loading loading-spinner" />
        : link->Option.isSome
        ? <Icon.check className="resp-icon" />
        : <Icon.plus className="resp-icon" />}
    </button>
  </form>
}
