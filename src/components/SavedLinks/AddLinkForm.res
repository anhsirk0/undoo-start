open LinkStore
open Link
open Fetch
open Utils
open Heroicons

@react.component
let make = (~link: option<Link.t>=?) => {
  let {addLink, updateLink} = LinkStore.use()
  let (loading, setLoading) = React.useState(_ => false)
  let (value, setValue) = React.useState(_ => link->Option.map(l => l.url)->Option.getOr(""))
  let onChange = evt => {
    let target = ReactEvent.Form.target(evt)
    let newValue: string = target["value"]
    setValue(_ => newValue)
  }

  let name = link->Option.map(l => l.id->Int.toString ++ "-url")->Option.getOr("url")
  let clearText = _ => {
    setValue(_ => "")
    `input[name='${name}']`->Utils.querySelectAndThen(Utils.focus)
  }

  let onSave = async () => {
    setLoading(_ => true)
    let title = await Fetch.getTitle(value)
    let id = link->Option.map(l => l.id)->Option.getOr(Date.now()->Float.toInt)
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
      className="input input-primary input-sm xxl:input-md flex items-center join-item grow">
      <InputBase
        required=true name className="grow" value onChange placeholder="Add url" disabled=loading
      />
      {value->String.length > 0
        ? <button
            disabled=loading
            onClick=clearText
            type_="button"
            className="btn btn-xs xxl:btn-sm btn-ghost btn-circle text-base-content/60">
            <Solid.XIcon />
          </button>
        : React.null}
    </label>
    <button disabled=loading className="btn btn-primary btn-sm xxl:btn-md no-animation join-item">
      {loading
        ? <span className="loading loading-spinner" />
        : link->Option.isSome
        ? <Solid.CheckIcon className="resp-icon" />
        : <Solid.PlusIcon className="resp-icon" />}
    </button>
  </form>
}
