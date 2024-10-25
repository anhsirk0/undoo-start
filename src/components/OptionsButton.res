include Hooks
include Store

open Heroicons

@react.component
let make = (~page: option<Page.t>) => {
  Hooks.useDocTitle(page->Option.map(p => p.title))
  let store = Store.use()

  let (isOpen, setIsOpen) = React.useState(_ => false)
  let toggleOpen = _ => setIsOpen(val => !val)

  let onSubmit = evt => {
    JsxEvent.Form.preventDefault(evt)
    let title = ReactEvent.Form.target(evt)["title"]["value"]
    let openLinkInNewTab = ReactEvent.Form.target(evt)["link-in-new-tab"]["checked"]
    let showPageTitle = ReactEvent.Form.target(evt)["page-title-in-document-title"]["checked"]
    let useSearcher = ReactEvent.Form.target(evt)["use-searcher"]["checked"]
    let hideEditButton = ReactEvent.Form.target(evt)["hide-edit-btn"]["checked"]
    let hideAddButton = ReactEvent.Form.target(evt)["hide-add-btn"]["checked"]
    let alwaysShowHints = ReactEvent.Form.target(evt)["always-show-hints"]["checked"]

    store.updateOptions({
      title,
      showPageTitle,
      useSearcher,
      hideEditButton,
      hideAddButton,
      alwaysShowHints,
      openLinkInNewTab,
    })
    toggleOpen()
  }

  <React.Fragment>
    <button
      ariaLabel="options-btn"
      onClick=toggleOpen
      className={`btn resp-btn sidebar-btn ${isOpen ? "btn-accent" : "btn-ghost"}`}>
      <Solid.AdjustmentsIcon className="resp-icon" />
    </button>
    {isOpen
      ? <Modal title="Options" onClose=toggleOpen>
          <form onSubmit className="flex flex-col gap-2 xl:gap-4 [&>div]:min-w-[100%]">
            <Input
              name="title" label="Document title" required=true defaultValue=store.options.title
            />
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
              name="use-searcher"
              defaultChecked=store.options.useSearcher
              label="Enable Silver Searcher"
            />
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
            <div className="flex flex-row gap-4 mt-4">
              <div className="grow" />
              <button className="btn resp-btn btn-primary"> {React.string("Save")} </button>
            </div>
          </form>
        </Modal>
      : React.null}
  </React.Fragment>
}
