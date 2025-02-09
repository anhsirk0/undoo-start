open ReactEvent

@react.component
let make = (~onClose) => {
  let (activeTab, setActiveTab) = React.useState(_ => Shape.OptionTabs.General)

  let store = Store.Options.use()
  let bgStore = Store.Bg.use()

  let (img, setImg) = React.useState(_ => "")
  let (imgName, setImgName) = React.useState(_ => "")

  let onSubmit = evt => {
    evt->Form.preventDefault
    if activeTab == Background {
      let bgOpacity = Form.target(evt)["bg-opacity"]["value"]
      let searcherOpacity = Form.target(evt)["searcher-opacity"]["value"]
      let searchOpacity = Form.target(evt)["search-opacity"]["value"]
      // let sidebarOpacity = Form.target(evt)["sidebar-opacity"]["value"]

      let imgExists = img->String.length > 20
      let image = imgExists ? img : bgStore.options.image
      let imageName = imgExists ? imgName : bgStore.options.imageName
      bgStore.update({
        image,
        imageName,
        bgOpacity,
        searchOpacity,
        searcherOpacity,
        // sidebarOpacity,
      })
    } else {
      let title = Form.target(evt)["title"]["value"]
      let openLinkInNewTab = Form.target(evt)["link-in-new-tab"]["checked"]
      let showPageTitle = Form.target(evt)["page-title-in-document-title"]["checked"]
      let useSearcher = Form.target(evt)["use-searcher"]["checked"]
      let useLinks = Form.target(evt)["use-links"]["checked"]
      let hideEditButton = Form.target(evt)["hide-edit-btn"]["checked"]
      let hideAddButton = Form.target(evt)["hide-add-btn"]["checked"]
      let hideOptionsButton = Form.target(evt)["hide-options-btn"]["checked"]
      let hideThemeButton = Form.target(evt)["hide-theme-btn"]["checked"]
      let hidePageSwitcher = Form.target(evt)["hide-page-switcher"]["checked"]
      let alwaysShowHints = Form.target(evt)["always-show-hints"]["checked"]
      let circleIcons = Form.target(evt)["circle-icons"]["checked"]

      store.updateOptions({
        title,
        showPageTitle,
        useSearcher,
        useLinks,
        hideEditButton,
        hideAddButton,
        hideOptionsButton,
        hideThemeButton,
        hidePageSwitcher,
        alwaysShowHints,
        circleIcons,
        openLinkInNewTab,
      })
    }
    onClose()
  }

  let makeTab = (tab, title) => {
    let className = `tab ${activeTab == tab ? "tab-active" : ""}`
    <a role="tab" className onClick={_ => setActiveTab(_ => tab)}> {title->React.string} </a>
  }

  <Modal title="Options" onClose classes="min-w-[66vw]">
    <div role="tablist" className="tabs tabs-bordered">
      {makeTab(General, "General")}
      {makeTab(Background, "Background")}
      {makeTab(ImportExport, "Import/Export")}
    </div>
    <form
      onSubmit
      className="flex flex-col xxl:gap-2 [&>div]:min-w-[100%] min-h-[60vh] pt-2 xxl:pt-4"
      tabIndex=0>
      {switch activeTab {
      | General => <GeneralOptions />
      | Background => <BackgroundOptions setImg setImgName />
      | ImportExport => <ImportExport />
      }}
    </form>
  </Modal>
}
