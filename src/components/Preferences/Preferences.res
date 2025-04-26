@react.component
let make = (~onClose) => {
  let (activeTab, setActiveTab) = React.useState(_ => Shape.OptionTabs.SearchEngine)

  let makeTab = (tab, title) => {
    let className = `tab flex-1 ${activeTab == tab ? "tab-active" : ""} whitespace-nowrap`
    <a role="tab" className onClick={_ => setActiveTab(_ => tab)}> {title->React.string} </a>
  }

  <Modal title="Options" onClose classes="min-w-[66vw]">
    <div role="tablist" className="tabs tabs-border w-full">
      {makeTab(General, "General")}
      {makeTab(Background, "Background")}
      {makeTab(ImportExport, "Import/Export")}
      {makeTab(SearchEngine, "Search engines")}
    </div>
    {switch activeTab {
    | General => <GeneralOptions />
    | Background => <BackgroundOptions />
    | ImportExport => <ImportExport />
    | SearchEngine => <SearchEngineOptions />
    }}
  </Modal>
}
