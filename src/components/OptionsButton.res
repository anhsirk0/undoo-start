include Hooks

open Heroicons

@react.component
let make = (~page: option<Page.t>) => {
  Hooks.useDocTitle(page)
  let store = Store.use()

  let (isOpen, setIsOpen) = React.useState(_ => false)
  let toggleOpen = _ => setIsOpen(val => !val)

  let onSubmit = evt => {
    JsxEvent.Form.preventDefault(evt)
    let title = ReactEvent.Form.target(evt)["title"]["value"]
    let openLinkInNewTab = ReactEvent.Form.target(evt)["link-in-new-tab"]["checked"]
    let showPageTitle = ReactEvent.Form.target(evt)["page-title-in-document-title"]["checked"]
    store.updateOptions(~title, ~showPageTitle, ~openLinkInNewTab)
    toggleOpen()
  }

  <React.Fragment>
    <button
      ariaLabel="options-btn"
      onClick=toggleOpen
      className={`btn animate-grow sidebar-btn ${isOpen ? "btn-accent" : "btn-ghost"}`}>
      <Solid.AdjustmentsIcon className="resp-icon" />
    </button>
    {isOpen
      ? <Modal title="Options" onClose=toggleOpen>
          <form onSubmit className="flex flex-col gap-2 xl:gap-4 [&>div]:min-w-[50%]">
            <Input name="title" label="Document title" required=true defaultValue=store.title />
            <Checkbox
              name="page-title-in-document-title"
              defaultChecked=store.showPageTitle
              label="Show active page title in Document title"
            />
            <Checkbox
              name="link-in-new-tab"
              defaultChecked=store.openLinkInNewTab
              label="Open links in new tab"
            />
            <div className="flex flex-row gap-4 mt-4">
              <div className="grow" />
              <button className="btn resp-btn btn-primary"> {React.string("Save")} </button>
            </div>
          </form>
        </Modal>
      : React.null}
  </React.Fragment>
}
