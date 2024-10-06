include Site
open Heroicons

@react.component
let make = (~addSite: Site.t => unit) => {
  let (chosenIcon, setChosenIcon) = React.useState(_ => None)
  let (isIconError, setIsIconError) = React.useState(_ => false)
  let (isOpen, setIsOpen) = React.useState(_ => false)
  let toggleOpen = _ => setIsOpen(val => !val)

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
        addSite({
          title,
          url,
          icon,
          showLabel,
          id: Date.now()->Belt.Float.toInt,
        })
        toggleOpen()
      }
    | None => setIsIconError(_ => true)
    }
  }

  <React.Fragment>
    <button
      onClick=toggleOpen
      className="fixed bottom-4 right-4 btn btn-neutral resp-btn btn-circle animate-grow">
      <Solid.PlusIcon className="resp-icon" />
    </button>
    {isOpen
      ? <Modal title="New Site" onClose=toggleOpen>
          <form onSubmit className="flex flex-col gap-4">
            <Input name="title" label="Title" required=true />
            <div className="form-control w-fit">
              <label className="label cursor-pointer">
                <span className="label-text pr-4"> {React.string("Show label")} </span>
                <input name="label" type_="checkbox" defaultChecked=true className="checkbox" />
              </label>
            </div>
            <Input name="url" label="Url" required=true />
            <ChooseIcon chosen=chosenIcon onChoose isIconError />
            <div className="flex flex-row gap-4 mt-4">
              <div className="grow" />
              <button className="btn resp-btn btn-primary"> {React.string("Add Site")} </button>
            </div>
          </form>
        </Modal>
      : React.null}
  </React.Fragment>
}
