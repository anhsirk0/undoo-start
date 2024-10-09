@module("../../helpers/setValue") external setValue: (Dom.element, string) => unit = "default"

include Site
open Heroicons

@react.component
let make = (~addSite: Site.t => unit) => {
  let (chosenIcon, setChosenIcon) = React.useState(_ => None)
  let (isIconError, setIsIconError) = React.useState(_ => false)
  let (isOpen, setIsOpen) = React.useState(_ => false)
  let toggleOpen = _ => {
    setIsOpen(val => !val)
    setChosenIcon(_ => None)
  }

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
      ariaLabel="add-site-btn"
      onClick=toggleOpen
      className="fixed bottom-2 xxl:bottom-5 right-2 xxl:right-4 btn btn-ghost resp-btn btn-circle animate-grow">
      <Solid.PlusIcon className="resp-icon" />
    </button>
    {isOpen
      ? <Modal title="New Site" onClose=toggleOpen classes="min-w-[62vw]">
          <form onSubmit className="flex flex-col gap-2 xl:gap-4">
            <div className="flex flex-col lg:flex-row gap-4 xxl:gap-8">
              <div className="flex flex-col gap-2 xl:gap-4 w-1/3 shrink-0">
                <Input name="title" label="Title" required=true />
                <Input name="url" label="Url" required=true />
                <Input name="icon" label="Icon" />
              </div>
              <div className="flex flex-col">
                <ChooseIcon chosen=chosenIcon onChoose isIconError />
              </div>
            </div>
            <div className="flex flex-row gap-4 mt-4">
              <Checkbox name="label" defaultChecked=true label="Show label" />
              <div className="grow" />
              <button className="btn resp-btn btn-primary"> {React.string("Add Site")} </button>
            </div>
          </form>
        </Modal>
      : React.null}
  </React.Fragment>
}
