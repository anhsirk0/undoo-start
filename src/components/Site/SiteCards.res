include Store
include Utils
open Heroicons

@react.component
let make = (~page: Page.t, ~isEditing) => {
  let store = Store.use()

  let updateSite = (site: Site.t) =>
    store.updatePage({...page, sites: page.sites->Array.map(s => s.id == site.id ? site : s)})

  let addSite = (site: Site.t) =>
    store.updatePage({...page, sites: page.sites->Array.concat([site])})

  let cards = Array.mapWithIndex(page.sites, (site, index) => {
    let onDelete = evt => {
      JsxEvent.Mouse.stopPropagation(evt)
      store.updatePage({...page, sites: page.sites->Array.filter(s => s.id != site.id)})
    }

    let onMoveLeft = evt => {
      JsxEvent.Mouse.stopPropagation(evt)
      store.updatePage({...page, sites: page.sites->Utils.moveLeft(index)})
    }

    let onMoveRight = evt => {
      JsxEvent.Mouse.stopPropagation(evt)
      store.updatePage({...page, sites: page.sites->Utils.moveRight(index)})
    }

    <SiteCard site key={Int.toString(site.id)} isEditing updateSite>
      <div
        role="button"
        ariaLabel={`delete-site-${site.title}-btn`}
        onClick=onDelete
        className="bg-error/60 absolute top-0 right-0 size-8 lg:size-10 xxl:size-12 center resp-text rounded-bl-box">
        <Solid.TrashIcon className="resp-icon text-base-content" />
        {page.sites->Array.length > 1
          ? <MoveSiteButtons onMoveLeft onMoveRight title=site.title />
          : React.null}
      </div>
    </SiteCard>
  })

  <React.Fragment>
    <div className="grid grid-cols-12 gap-4 lg:gap-6 xl:gap-8 xxl:gap-12 w-full">
      {React.array(cards)}
    </div>
    <AddSiteButton addSite />
  </React.Fragment>
}
