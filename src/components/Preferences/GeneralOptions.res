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
        <p className="text-xs xl:text-sm xxl:text-base text-base-content/60">
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
        className="toggle toggle-sm xxl:toggle-md toggle-primary"
        name
        defaultChecked=value
      />
    </div>
  }
}

@react.component
let make = () => {
  let store = Store.Options.use()

  <React.Fragment>
    <Input name="title" label="Document title" required=true defaultValue=store.options.title />
    <div className="grid grid-cols-2 grow gap-4 xxl:gap-6 pt-4">
      <div
        className="col-span-1 flex flex-col gap-2 xxl:gap-4 h-full border border-base-content/20 rounded-box p-4">
        <Item
          name="page-title-in-document-title"
          value=store.options.showPageTitle
          label="Show active page title in Document title"
        />
        <Item
          name="link-in-new-tab" value=store.options.openLinkInNewTab label="Open links in new tab"
        />
        <Item name="circle-icons" value=store.options.circleIcons label="Use circle icons" />
        <Item
          name="always-show-hints"
          value=store.options.alwaysShowHints
          label="Always show site hints"
          shortKey="SPACE"
          keyMsg=" to show hints temporarily"
        />
        <Item
          name="hide-searcher-btn"
          value=store.options.hideSearcherButton
          label="Hide Searcher button"
          shortKey="?"
        />
        <Item
          name="hide-links-btn" value=store.options.hideLinksButton label="Hide Saved Links button"
        />
      </div>
      <div
        className="col-span-1 flex flex-col gap-2 xxl:gap-4 h-full border border-base-content/20 rounded-box p-4">
        <Item
          name="hide-edit-btn"
          value=store.options.hideEditButton
          label="Hide edit button"
          shortKey="-"
          keyMsg=" or right click anywhere"
        />
        <Item
          name="hide-add-btn" value=store.options.hideAddButton label="Hide add button" shortKey="+"
        />
        <Item
          name="hide-page-switcher"
          value=store.options.hidePageSwitcher
          label="Hide page switcher"
          keyMsg="you can always use ScrollUp/ScrollDown"
        />
        <Item
          name="hide-options-btn"
          value=store.options.hideOptionsButton
          label="Hide options button"
          shortKey="."
        />
        <Item
          name="hide-theme-btn"
          value=store.options.hideThemeButton
          label="Hide theme button"
          shortKey=","
        />
      </div>
    </div>
    <div className="flex flex-row mt-4 justify-end">
      <button className="btn resp-btn btn-primary"> {React.string("Save")} </button>
    </div>
  </React.Fragment>
}
