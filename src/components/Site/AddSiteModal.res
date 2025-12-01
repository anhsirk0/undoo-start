@react.component
let make = (~site: option<Shape.Site.t>, ~onClose, ~onSubmit) => {
  let (chosenIcon, setChosenIcon) = React.useState(_ => site->Option.map(s => s.icon))
  let (isIconError, _, setIsIconError) = Hook.useToggle()
  let (bookmarks, setBookmarks) = React.useState(_ => [])
  let (choosingBookmark, toggleChoosingBookmark, _) = Hook.useToggle()

  let defaultBgcolor = site->Option.flatMap(s => s.bgcolor)->Option.getOr("#fff")

  let onChoose = str => {
    setChosenIcon(_ => Some(str))
    setIsIconError(_ => false)
    "input[name='icon']"->Utils.querySelectAndThen(Utils.setValue(_, str))
  }

  let setUrl = text => "input[name='url']"->Utils.querySelectAndThen(Utils.setValue(_, text))
  let setTitle = text => "input[name='title']"->Utils.querySelectAndThen(Utils.setValue(_, text))

  let pasteFromClipboard = async _ => {
    let text = await Utils.readClipboard()
    text->setUrl
  }

  let makeFromUrl = _ => {
    "input[name='url']"->Utils.querySelectAndThen(el => {
      let name =
        el
        ->Utils.getValue
        ->Utils.makeTitleFromUrl
      name->setTitle
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

  React.useEffect0(() => {
    Browser.getAllBookmarks()->Promise.then(async arr => setBookmarks(_ => arr))->ignore
    None
  })

  <Modal
    title={site->Option.map(s => s.title)->Option.getOr("New Site")}
    onClose
    classes="min-w-[80vw] xl:min-w-[64vw] min-h-0">
    <form
      onSubmit=handleSubmit
      className="flex flex-col max-h-[80vh] 2xl:max-h-[60vh] gap-2 xl:gap-4 h-full min-h-0"
      tabIndex=0>
      <div className="flex flex-col lg:flex-row gap-4 2xl:gap-8 min-h-0">
        <div className="flex flex-col gap-2 xl:gap-4 w-[45%] shrink-0 grow min-h-0">
          {choosingBookmark
            ? <ChooseFromBookmarks
                bookmarks
                onClose=toggleChoosingBookmark
                onSubmit={it => {
                  toggleChoosingBookmark()
                  setTimeout(() => {
                    it.url->setUrl
                    it.title->setTitle
                  }, 100)
                }}
              />
            : <React.Fragment>
                <FormControl label="Url">
                  <label
                    className="input input-bordered input-sm 2xl:input-md w-full flex items-center gap-2">
                    <InputBase name="url" className="grow" required=true defaultValue=data.url />
                    <button
                      type_="button"
                      className="btn btn-xs xl:btn-sm -mr-2"
                      onClick={_ => pasteFromClipboard()->ignore}>
                      <Icon.clipboardText className="size-4" />
                    </button>
                  </label>
                </FormControl>
                <FormControl label="Title">
                  <label
                    className="input input-bordered input-sm 2xl:input-md w-full flex items-center gap-2">
                    <InputBase
                      name="title" className="grow" required=true defaultValue=data.title
                    />
                    <button
                      type_="button" className="btn btn-xs xl:btn-sm -mr-2" onClick=makeFromUrl>
                      {"Make from Url"->React.string}
                    </button>
                  </label>
                </FormControl>
                <Input name="icon" label="Icon" defaultValue=data.icon />
                <label className="form-control w-fit flex-col">
                  <div className="label">
                    <span className="label-text"> {"Bgcolor"->React.string} </span>
                  </div>
                  <div className="rounded-btn border border-neutral center overflow-hidden">
                    <input
                      defaultValue=defaultBgcolor type_="color" name="bgcolor" className="scale-150"
                    />
                  </div>
                </label>
              </React.Fragment>}
        </div>
        <div className="flex flex-col overflow-y-auto min-h-0">
          <ChooseIcon chosen=chosenIcon onChoose isIconError />
        </div>
      </div>
      <div className="flex flex-row gap-4 mt-4">
        <Checkbox name="label" defaultChecked=data.showLabel label="Show label" />
        <div className="grow" />
        {bookmarks->Array.length > 0
          ? <button
              type_="button"
              onClick={_ => toggleChoosingBookmark()}
              className="btn resp-btn btn-accent btn-outline">
              {"Choose from bookmarks"->React.string}
            </button>
          : React.null}
        <button className="btn resp-btn btn-primary">
          {(site->Option.isSome ? "Update site" : "Add site")->React.string}
        </button>
      </div>
    </form>
  </Modal>
}
