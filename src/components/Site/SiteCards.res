open Store
open Page
open Site
open Utils
open Heroicons

@react.component
let make = (~page: Page.t, ~isEditing, ~isVisiting) => {
  let store = Store.use()

  let updateSite = (site: Site.t) =>
    store.updatePage({...page, sites: page.sites->Array.map(s => s.id == site.id ? site : s)})

  let addSite = (site: Site.t) =>
    store.updatePage({...page, sites: page.sites->Array.concat([site])})

  let cards = page.sites->Array.mapWithIndex((site, index) => {
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

    let index = Some(index + 97)->Option.filter(_ => isVisiting || store.options.alwaysShowHints)

    <SiteCard site key={Int.toString(site.id)} isEditing updateSite index>
      <div
        role="button"
        ariaLabel={`delete-site-${site.title}-btn`}
        onClick=onDelete
        className="absolute top-0 right-0 size-8 lg:size-10 xxl:size-12 center resp-text rounded-bl-box">
        <Solid.TrashIcon className="resp-icon text-error" />
      </div>
      {page.sites->Array.length > 1
        ? <MoveSiteButtons onMoveLeft onMoveRight title=site.title />
        : React.null}
    </SiteCard>
  })

  <React.Fragment>
    <div className="grid grid-cols-12 gap-4 lg:gap-6 xl:gap-8 xxl:gap-12 w-full">
      {React.array(cards)}
    </div>
    <AddSiteButton addSite />
  </React.Fragment>
}
