module Item = {
  @react.component
  let make = (~name, ~value, ~label, ~shortKey=?, ~keyMsg=?) => {
    let msg = switch keyMsg {
    | Some(msg) => msg->React.string
    | None => React.null
    }
    <div className="flex gap-4 w-full">
      <div className="flex flex-col grow">
        <p className="text-sm xl:text-lg"> {label->React.string} </p>
        <p className="text-xs xl:text-sm 2xl:text-base text-base-content/60">
          {switch shortKey {
          | Some(k) =>
            <React.Fragment>
              {"You can always use "->React.string}
              <kbd className="kbd w-fit"> {k->React.string} </kbd>
              {" key"->React.string}
              {msg}
            </React.Fragment>
          | None => msg
          }}
        </p>
      </div>
      <input
        type_="checkbox"
        className="toggle toggle-sm 2xl:toggle-md toggle-primary"
        name
        defaultChecked=value
      />
    </div>
  }
}

@react.component
let make = (~onClose) => {
  let {options, updateOptions} = Store.Options.use()

  let onSubmit = evt => {
    evt->ReactEvent.Form.preventDefault
    let target = evt->ReactEvent.Form.target
    let title = target["title"]["value"]
    let openLinkInNewTab = target["link-in-new-tab"]["checked"]
    let showPageTitle = target["page-title-in-document-title"]["checked"]
    let hideSearcherButton = target["hide-searcher-btn"]["checked"]
    let hideLinksButton = target["hide-links-btn"]["checked"]
    let hideEditButton = target["hide-edit-btn"]["checked"]
    let hideAddButton = target["hide-add-btn"]["checked"]
    let hideOptionsButton = target["hide-options-btn"]["checked"]
    let hideThemeButton = target["hide-theme-btn"]["checked"]
    let hidePageSwitcher = target["hide-page-switcher"]["checked"]
    let alwaysShowHints = target["always-show-hints"]["checked"]
    let alwaysShowSidebar = target["always-show-sidebar"]["checked"]
    let circleIcons = target["circle-icons"]["checked"]

    updateOptions({
      title,
      showPageTitle,
      hideSearcherButton,
      hideLinksButton,
      hideEditButton,
      hideAddButton,
      hideOptionsButton,
      hideThemeButton,
      hidePageSwitcher,
      alwaysShowHints,
      alwaysShowSidebar,
      circleIcons,
      openLinkInNewTab,
    })
    onClose()
  }

  <form
    onSubmit
    className="flex flex-col 2xl:gap-2 [&>div]:min-w-[100%] min-h-[60vh] pt-2 2xl:pt-4"
    tabIndex=0>
    <Input name="title" label="Document title" required=true defaultValue=options.title />
    <div className="grid grid-cols-2 grow gap-4 2xl:gap-6 pt-4">
      <div
        className="col-span-1 flex flex-col gap-2 2xl:gap-4 h-full border border-base-content/20 rounded-box p-4">
        <Item
          name="page-title-in-document-title"
          value=options.showPageTitle
          label="Show active page title in Document title"
        />
        <Item name="link-in-new-tab" value=options.openLinkInNewTab label="Open links in new tab" />
        <Item name="circle-icons" value=options.circleIcons label="Use circle icons" />
        <Item
          name="always-show-sidebar" value=options.alwaysShowSidebar label="Always show sidebar"
        />
        <Item
          name="always-show-hints"
          value=options.alwaysShowHints
          label="Always show site hints"
          shortKey="SPACE"
          keyMsg=" to show hints temporarily"
        />
        <Item
          name="hide-searcher-btn"
          value=options.hideSearcherButton
          label="Hide Searcher button"
          shortKey="?"
        />
        <Item name="hide-links-btn" value=options.hideLinksButton label="Hide Saved Links button" />
      </div>
      <div
        className="col-span-1 flex flex-col gap-2 2xl:gap-4 h-full border border-base-content/20 rounded-box p-4">
        <Item
          name="hide-edit-btn"
          value=options.hideEditButton
          label="Hide edit button"
          shortKey="-"
          keyMsg=" or right click anywhere"
        />
        <Item
          name="hide-add-btn" value=options.hideAddButton label="Hide add button" shortKey="+"
        />
        <Item
          name="hide-page-switcher"
          value=options.hidePageSwitcher
          label="Hide page switcher"
          keyMsg="you can always use ScrollUp/ScrollDown"
        />
        <Item
          name="hide-options-btn"
          value=options.hideOptionsButton
          label="Hide options button"
          shortKey="."
        />
        <Item
          name="hide-theme-btn" value=options.hideThemeButton label="Hide theme button" shortKey=","
        />
      </div>
    </div>
    <div className="flex flex-row mt-4 justify-end">
      <button className="btn resp-btn btn-primary"> {React.string("Save")} </button>
    </div>
  </form>
}
