include Site

@react.component
let make = (~site: Site.t, ~onClose, ~updateSite) => {
  let (chosenIcon, setChosenIcon) = React.useState(_ => None)
  let (isIconError, setIsIconError) = React.useState(_ => false)

  let onChoose = str => {
    setChosenIcon(_ => Some(str))
    setIsIconError(_ => false)
  }

  let onSubmit = evt => {
    JsxEvent.Form.preventDefault(evt)
    let title = ReactEvent.Form.target(evt)["title"]["value"]
    let url = ReactEvent.Form.target(evt)["url"]["value"]
    let iconVal = ReactEvent.Form.target(evt)["icon"]["value"]
    let showLabel = ReactEvent.Form.target(evt)["label"]["checked"]

    let icon = iconVal->String.length > 0 ? Some(iconVal) : chosenIcon
    switch icon {
    | Some(icon) => {
        updateSite({...site, title, url, icon, showLabel})
        onClose()
      }
    | None => setIsIconError(_ => true)
    }
  }

  <Modal title=site.title onClose>
    <form onSubmit className="flex flex-col gap-4">
      <Input name="title" defaultValue=site.title label="Title" />
      <div className="form-control w-fit">
        <label className="label cursor-pointer">
          <span className="label-text pr-4"> {React.string("Show label")} </span>
          <input name="label" type_="checkbox" defaultChecked=site.showLabel className="checkbox" />
        </label>
      </div>
      <Input name="url" defaultValue=site.url label="Url" />
      <ChooseIcon chosen=chosenIcon onChoose isIconError />
      <div className="flex flex-row gap-4 mt-4 justify-end">
        <button className="btn resp-btn btn-primary"> {React.string("Update site")} </button>
      </div>
    </form>
  </Modal>
}
