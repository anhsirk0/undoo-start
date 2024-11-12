open Hooks
open Store
open BgStore
open Page
open Heroicons

@react.component
let make = (~page: option<Page.t>) => {
  Hooks.useDocTitle(page->Option.map(p => p.title))
  let store = Store.use()
  let bgStore = BgStore.use()

  let (isOpen, toggleOpen, _) = Hooks.useToggle()
  let (isCustomizingBg, toggleCustomizingBg, _) = Hooks.useToggle()
  let (img, setImg) = React.useState(_ => "")
  let (imgName, setImgName) = React.useState(_ => "")

  let onSubmit = evt => {
    ReactEvent.Form.preventDefault(evt)
    if isCustomizingBg {
      let bgOpacity = ReactEvent.Form.target(evt)["bg-opacity"]["value"]
      let searcherOpacity = ReactEvent.Form.target(evt)["searcher-opacity"]["value"]
      let searchOpacity = ReactEvent.Form.target(evt)["search-opacity"]["value"]
      let sidebarOpacity = ReactEvent.Form.target(evt)["sidebar-opacity"]["value"]

      let imgExists = img->String.length > 20
      let image = imgExists ? img : bgStore.options.image
      let imageName = imgExists ? imgName : bgStore.options.imageName
      bgStore.update({
        image,
        imageName,
        bgOpacity,
        searchOpacity,
        searcherOpacity,
        sidebarOpacity,
      })
      toggleCustomizingBg()
    } else {
      let title = ReactEvent.Form.target(evt)["title"]["value"]
      let openLinkInNewTab = ReactEvent.Form.target(evt)["link-in-new-tab"]["checked"]
      let showPageTitle = ReactEvent.Form.target(evt)["page-title-in-document-title"]["checked"]
      let useSearcher = ReactEvent.Form.target(evt)["use-searcher"]["checked"]
      let hideEditButton = ReactEvent.Form.target(evt)["hide-edit-btn"]["checked"]
      let hideAddButton = ReactEvent.Form.target(evt)["hide-add-btn"]["checked"]
      let alwaysShowHints = ReactEvent.Form.target(evt)["always-show-hints"]["checked"]
      let circleIcons = ReactEvent.Form.target(evt)["circle-icons"]["checked"]

      store.updateOptions({
        title,
        showPageTitle,
        useSearcher,
        hideEditButton,
        hideAddButton,
        alwaysShowHints,
        circleIcons,
        openLinkInNewTab,
      })
      toggleOpen()
    }
  }

  <React.Fragment>
    <button
      ariaLabel="options-btn"
      id="options-btn"
      onClick={_ => toggleOpen()}
      className={`btn resp-btn sidebar-btn ${isOpen ? "btn-accent" : "btn-ghost"}`}>
      <Solid.AdjustmentsIcon className="resp-icon" />
    </button>
    {isOpen
      ? <Modal title="Options" onClose=toggleOpen classes="min-w-[50vw]">
          <form
            onSubmit
            className="flex flex-col gap-2 xl:gap-4 [&>div]:min-w-[100%] min-h-[60vh]"
            tabIndex=0>
            {isCustomizingBg ? <CustomizeBackground setImg setImgName /> : <OptionsInputs />}
            <div className="grow" />
            <div className="flex flex-row gap-4 mt-4">
              <button
                onClick={_ => toggleCustomizingBg()}
                type_="button"
                className={`btn resp-btn ${isCustomizingBg ? "btn-neutral" : "btn-ghost"}`}>
                {React.string("Customize background")}
              </button>
              <div className="grow" />
              {isCustomizingBg
                ? <button className="btn resp-btn btn-primary">
                    {React.string("Save background")}
                  </button>
                : <button className="btn resp-btn btn-primary"> {React.string("Save")} </button>}
            </div>
          </form>
        </Modal>
      : React.null}
  </React.Fragment>
}
