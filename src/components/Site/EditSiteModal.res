include Site
include Utils

@react.component
let make = (~site: Site.t, ~onClose, ~updateSite) => {
  let (chosenIcon, setChosenIcon) = React.useState(_ => Some(site.icon))
  let (isIconError, setIsIconError) = React.useState(_ => false)

  let defaultBgcolor = site.bgcolor->Option.getOr("#000000")

  let onChoose = str => {
    setChosenIcon(_ => Some(str))
    setIsIconError(_ => false)

    switch ReactDOM.querySelector("input[name='icon'") {
    | Some(el) => el->Utils.setValue(str)
    | None => ()
    }
  }

  let onSubmit = evt => {
    JsxEvent.Form.preventDefault(evt)
    let target = ReactEvent.Form.target(evt)
    let title = target["title"]["value"]
    let url = target["url"]["value"]
    let bgcolor = target["bgcolor"]["value"]
    let iconVal = target["icon"]["value"]
    let showLabel = target["label"]["checked"]

    let icon = iconVal->String.length > 0 ? Some(iconVal) : chosenIcon
    switch icon {
    | Some(icon) => {
        updateSite({...site, title, url, icon, showLabel, bgcolor})
        onClose()
      }
    | None => setIsIconError(_ => true)
    }
  }

  <Modal title=site.title onClose classes="min-w-[70vw] xl:min-w-[62vw]">
    <form onSubmit className="flex flex-col gap-2 xl:gap-4">
      <div className="flex flex-col lg:flex-row gap-4 xxl:gap-8">
        <div className="flex flex-col gap-2 xl:gap-4 min-w-[50%] shrink-0">
          <Input name="title" defaultValue=site.title label="Title" />
          <Input name="url" defaultValue=site.url label="Url" />
          <Input name="icon" label="Icon" defaultValue=site.icon />
          <label className="form-control w-fit flex-col">
            <div className="label">
              <span className="label-text"> {React.string("Bgcolor")} </span>
            </div>
            <div className="rounded-btn border border-neutral center overflow-hidden">
              <input
                defaultValue=defaultBgcolor type_="color" name="bgcolor" className="scale-150"
              />
            </div>
          </label>
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
