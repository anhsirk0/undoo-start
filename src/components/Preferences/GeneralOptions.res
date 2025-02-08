@react.component
let make = () => {
  let store = Store.Options.use()

  <React.Fragment>
    <Input name="title" label="Document title" required=true defaultValue=store.options.title />
    <Checkbox
      name="page-title-in-document-title"
      defaultChecked=store.options.showPageTitle
      label="Show active page title in Document title"
    />
    <Checkbox
      name="link-in-new-tab"
      defaultChecked=store.options.openLinkInNewTab
      label="Open links in new tab"
    />
    <Checkbox
      name="use-searcher" defaultChecked=store.options.useSearcher label="Enable Silver Searcher"
    />
    <Checkbox name="use-links" defaultChecked=store.options.useLinks label="Enable Saved Links" />
    <Checkbox
      name="hide-edit-btn"
      defaultChecked=store.options.hideEditButton
      label="Hide edit button (you can always use RightClick or MinusKey)"
    />
    <Checkbox
      name="hide-add-btn"
      defaultChecked=store.options.hideAddButton
      label="Hide add button (you can always use PlusKey or EqualKey)"
    />
    <Checkbox
      name="always-show-hints"
      defaultChecked=store.options.alwaysShowHints
      label="Always show site hints"
    />
    <Checkbox
      name="circle-icons" defaultChecked=store.options.circleIcons label="Use circle icons"
    />
    <div className="grow" />
    <div className="flex flex-row mt-4 justify-end">
      <button className="btn resp-btn btn-primary"> {React.string("Save")} </button>
    </div>
  </React.Fragment>
}
