open Heroicons
open ReactEvent

@react.component
let make = (~page: option<Shape.Page.t>) => {
  Hook.useDocTitle(page->Option.map(p => p.title))
  let store = Store.Options.use()
  let bgStore = Store.Bg.use()

  let (isOpen, toggleOpen, _) = Hook.useToggle()
  let (isCustomizingBg, toggleCustomizingBg, _) = Hook.useToggle()
  let (img, setImg) = React.useState(_ => "")
  let (imgName, setImgName) = React.useState(_ => "")

  let onSubmit = evt => {
    evt->Form.preventDefault
    if isCustomizingBg {
      let bgOpacity = Form.target(evt)["bg-opacity"]["value"]
      let searcherOpacity = Form.target(evt)["searcher-opacity"]["value"]
      let searchOpacity = Form.target(evt)["search-opacity"]["value"]
      let sidebarOpacity = Form.target(evt)["sidebar-opacity"]["value"]

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
      let title = Form.target(evt)["title"]["value"]
      let openLinkInNewTab = Form.target(evt)["link-in-new-tab"]["checked"]
      let showPageTitle = Form.target(evt)["page-title-in-document-title"]["checked"]
      let useSearcher = Form.target(evt)["use-searcher"]["checked"]
      let useLinks = Form.target(evt)["use-links"]["checked"]
      let hideEditButton = Form.target(evt)["hide-edit-btn"]["checked"]
      let hideAddButton = Form.target(evt)["hide-add-btn"]["checked"]
      let alwaysShowHints = Form.target(evt)["always-show-hints"]["checked"]
      let circleIcons = Form.target(evt)["circle-icons"]["checked"]

      store.updateOptions({
        title,
        showPageTitle,
        useSearcher,
        useLinks,
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
