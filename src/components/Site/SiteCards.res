include Store

@react.component
let make = (~page: Page.t, ~isEditing) => {
  let store = Store.use()

  let updateSite = (site: Site.t) =>
    store.updatePage({...page, sites: page.sites->Array.map(s => s.id == site.id ? site : s)})

  let addSite = (site: Site.t) =>
    store.updatePage({...page, sites: page.sites->Array.concat([site])})

  let cards = Array.map(page.sites, site => {
    let onDelete = evt => {
      JsxEvent.Mouse.stopPropagation(evt)
      store.updatePage({...page, sites: page.sites->Array.filter(s => s.id != site.id)})
    }

    <SiteCard site key={Int.toString(site.id)} isEditing onDelete updateSite />
  })

  <React.Fragment>
    <div className="grid grid-cols-12 gap-4 lg:gap-6 xl:gap-8 xxl:gap-12 w-full">
      {React.array(cards)}
    </div>
    <AddSiteButton addSite />
  </React.Fragment>
}
