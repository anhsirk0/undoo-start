include Site

@react.component
let make = (~site: Site.t, ~onClose, ~updateSite) => {
  let onSubmit = evt => {
    JsxEvent.Form.preventDefault(evt)
    let title = ReactEvent.Form.target(evt)["title"]["value"]
    let url = ReactEvent.Form.target(evt)["url"]["value"]
    let icon = ReactEvent.Form.target(evt)["icon"]["value"]
    let showLabel = ReactEvent.Form.target(evt)["label"]["checked"]

    updateSite({...site, title, url, icon, showLabel})
    onClose()
  }

  <Modal title=site.title onClose>
    <form onSubmit className="flex flex-col gap-4">
      <Input name="title" defaultValue=site.title label="Title" />
      <Input name="url" defaultValue=site.url label="Url" />
      <Input name="icon" defaultValue=site.icon label="Icon" />
      <div className="form-control">
        <label className="label cursor-pointer">
          <span className="label-text"> {React.string("Show label")} </span>
          <input name="label" type_="checkbox" defaultChecked=site.showLabel className="checkbox" />
        </label>
      </div>
      <div className="flex flex-row gap-4 mt-4 justify-end">
        <button className="btn resp-btn btn-primary"> {React.string("Update site")} </button>
      </div>
    </form>
  </Modal>
}
