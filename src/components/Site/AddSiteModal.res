open Heroicons

@react.component
let make = (~site: option<Shape.Site.t>, ~onClose, ~onSubmit) => {
  let (chosenIcon, setChosenIcon) = React.useState(_ => site->Option.map(s => s.icon))
  let (isIconError, setIsIconError) = React.useState(_ => false)

  let defaultBgcolor = site->Option.flatMap(s => s.bgcolor)->Option.getOr("#fff")

  let onChoose = str => {
    setChosenIcon(_ => Some(str))
    setIsIconError(_ => false)
    "input[name='icon']"->Utils.querySelectAndThen(Utils.setValue(_, str))
  }

  let pasteFromClipboard = async _ => {
    let text = await Utils.readClipboard()
    "input[name='url']"->Utils.querySelectAndThen(Utils.setValue(_, text))
  }

  let makeFromUrl = _ => {
    "input[name='url']"->Utils.querySelectAndThen(el => {
      let name =
        el
        ->Utils.getValue
        ->Utils.makeTitleFromUrl

      "input[name='title']"->Utils.querySelectAndThen(Utils.setValue(_, name))
    })
  }

  let handleSubmit = evt => {
    ReactEvent.Form.preventDefault(evt)
    let target = ReactEvent.Form.target(evt)
    let title = target["title"]["value"]
    let url = target["url"]["value"]
    let bgcolor = target["bgcolor"]["value"]
    let iconVal = target["icon"]["value"]
    let showLabel = target["label"]["checked"]

    let icon = iconVal->String.length > 0 ? Some(iconVal) : chosenIcon
    switch icon {
    | Some(icon) => {
        switch site {
        | Some(s) => onSubmit({...s, title, url, icon, showLabel, bgcolor})
        | None =>
          onSubmit({
            id: Date.now(),
            title,
            url,
            icon,
            showLabel,
            bgcolor,
          })
        }
        onClose()
      }
    | None => setIsIconError(_ => true)
    }
  }

  let data = site->Option.getOr(Shape.Site.empty)

  <Modal
    title={site->Option.map(s => s.title)->Option.getOr("New Site")}
    onClose
    classes="min-w-[80vw] xl:min-w-[64vw] max-h-[99vh]">
    <form onSubmit=handleSubmit className="flex flex-col gap-2 xl:gap-4" tabIndex=0>
      <div className="flex flex-col lg:flex-row gap-4 2xl:gap-8">
        <div className="flex flex-col gap-2 xl:gap-4 min-w-[40%] shrink-0">
          <FormControl label="Url">
            <label
              className="input input-bordered input-sm 2xl:input-md w-full flex items-center gap-2">
              <InputBase name="url" className="grow" required=true defaultValue=data.url />
              <button
                type_="button"
                className="btn btn-xs xl:btn-sm -mr-2"
                onClick={_ => pasteFromClipboard()->ignore}>
                <Outline.ClipboardListIcon className="size-4" />
              </button>
            </label>
          </FormControl>
          <FormControl label="Title">
            <label
              className="input input-bordered input-sm 2xl:input-md w-full flex items-center gap-2">
              <InputBase name="title" className="grow" required=true defaultValue=data.title />
              <button type_="button" className="btn btn-xs xl:btn-sm -mr-2" onClick=makeFromUrl>
                {"Make from Url"->React.string}
              </button>
            </label>
          </FormControl>
          <Input name="icon" label="Icon" defaultValue=data.icon />
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
        <Checkbox name="label" defaultChecked=data.showLabel label="Show label" />
        <div className="grow" />
        <button className="btn resp-btn btn-primary">
          {(site->Option.isSome ? "Update site" : "Add site")->React.string}
        </button>
      </div>
    </form>
  </Modal>
}
