open Heroicons

@react.component
let make = (~addSite: Shape.Site.t => unit) => {
  let store = Store.Options.use()

  let (chosenIcon, setChosenIcon) = React.useState(_ => None)
  let (isIconError, setIsIconError) = React.useState(_ => false)

  let (isOpen, toggleIsOpen, _) = Hook.useToggle()

  let toggleOpen = _ => {
    toggleIsOpen()
    setChosenIcon(_ => None)
  }

  let onChoose = str => {
    setChosenIcon(_ => Some(str))
    setIsIconError(_ => false)
    "input[name='icon']"->Utils.querySelectAndThen(Utils.setValue(_, str))
  }

  let onExtractFromUrl = _ => {
    "input[name='url']"->Utils.querySelectAndThen(el => {
      let url =
        el
        ->Utils.getValue
        ->String.replace("https://", "")
        ->String.replace("www.", "")

      let name =
        Js.String.replaceByRe(
          %re("/\.(com|net|org|co|us|netlify.app)$/"),
          "",
          url
          ->String.split("/")
          ->Array.get(0)
          ->Option.getOr(url),
        )
        ->String.replaceAll(".", " ")
        ->Utils.toTitleCase
      "input[name='title']"->Utils.querySelectAndThen(Utils.setValue(_, name))
    })
  }

  let onSubmit = evt => {
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
        addSite({
          title,
          bgcolor,
          url,
          icon,
          showLabel,
          id: Date.now(),
        })
        toggleOpen()
      }
    | None => setIsIconError(_ => true)
    }
  }

  <React.Fragment>
    <button
      ariaLabel="add-site-btn"
      id="add-btn"
      onClick=toggleOpen
      className={store.options.hideAddButton
        ? "hidden"
        : "fixed bottom-2 xxl:bottom-5 right-2 xxl:right-4 btn btn-ghost resp-btn btn-circle animate-grow"}>
      <Solid.PlusIcon className="resp-icon" />
    </button>
    {isOpen
      ? <Modal title="New Site" onClose=toggleOpen classes="min-w-[70vw] xl:min-w-[62vw]">
          <form onSubmit className="flex flex-col gap-2 xl:gap-4" tabIndex=0>
            <div className="flex flex-col lg:flex-row gap-4 xxl:gap-8">
              <div className="flex flex-col gap-2 xl:gap-4 min-w-[50%] shrink-0">
                <Input type_="url" name="url" label="Url" required=true />
                <FormControl label="Title">
                  <label
                    className="input input-bordered input-sm xxl:input-md w-full flex items-center gap-2">
                    <InputBase name="title" className="grow" required=true />
                    <button type_="button" className="btn-sm" onClick=onExtractFromUrl>
                      {"Extract from Url"->React.string}
                    </button>
                  </label>
                </FormControl>
                // <Input name="title" label="Title" required=true />
                <Input name="icon" label="Icon" />
                <label className="form-control w-fit flex-col">
                  <div className="label">
                    <span className="label-text"> {React.string("Bgcolor")} </span>
                  </div>
                  <div className="rounded-btn border border-neutral center overflow-hidden">
                    <input type_="color" name="bgcolor" className="scale-150" />
                  </div>
                </label>
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
