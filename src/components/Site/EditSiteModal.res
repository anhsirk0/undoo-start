@module("../../helpers/setValue") external setValue: (Dom.element, string) => unit = "default"

include Site

@react.component
let make = (~site: Site.t, ~onClose, ~updateSite) => {
  let (chosenIcon, setChosenIcon) = React.useState(_ => Some(site.icon))
  let (isIconError, setIsIconError) = React.useState(_ => false)

  let onChoose = str => {
    setChosenIcon(_ => Some(str))
    setIsIconError(_ => false)

    switch ReactDOM.querySelector("input[name='icon'") {
    | Some(el) => el->setValue(str)
    | None => ()
    }
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

  <Modal title=site.title onClose classes="min-w-[62vw]">
    <form onSubmit className="flex flex-col gap-2 xl:gap-4">
      <div className="flex flex-col lg:flex-row gap-4 xxl:gap-8">
        <div className="flex flex-col gap-2 xl:gap-4 w-1/3 shrink-0">
          <Input name="title" defaultValue=site.title label="Title" />
          <Input name="url" defaultValue=site.url label="Url" />
          <Input name="icon" label="Icon" defaultValue=site.icon />
        </div>
        <div className="flex flex-col">
          <ChooseIcon chosen=chosenIcon onChoose isIconError />
        </div>
      </div>
      <div className="flex flex-row gap-4 mt-4">
        <Checkbox name="label" defaultChecked=site.showLabel label="Show label" />
        <div className="grow" />
        <button className="btn resp-btn btn-primary"> {React.string("Update site")} </button>
      </div>
    </form>
  </Modal>
}
