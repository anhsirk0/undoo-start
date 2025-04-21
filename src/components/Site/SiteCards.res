open Heroicons

@react.component
let make = (~page: Shape.Page.t, ~isEditing, ~isVisiting) => {
  let {options, updatePage} = Store.Options.use()

  let updateSite = (site: Shape.Site.t) =>
    updatePage({...page, sites: page.sites->Array.map(s => s.id == site.id ? site : s)})

  let addSite = (site: Shape.Site.t) =>
    updatePage({...page, sites: page.sites->Array.concat([site])})

  let cards = page.sites->Array.mapWithIndex((site, index) => {
    let onDelete = evt => {
      ReactEvent.Mouse.stopPropagation(evt)
      updatePage({...page, sites: page.sites->Array.filter(s => s.id != site.id)})
    }

    let onMoveLeft = evt => {
      ReactEvent.Mouse.stopPropagation(evt)
      updatePage({...page, sites: page.sites->Utils.moveLeft(index)})
    }

    let onMoveRight = evt => {
      ReactEvent.Mouse.stopPropagation(evt)
      updatePage({...page, sites: page.sites->Utils.moveRight(index)})
    }

    let index = Some(index + 97)->Option.filter(_ => isVisiting || options.alwaysShowHints)
    let pos = options.circleIcons ? "top-2 right-2" : "top-0 right-0"

    <SiteCard site key={site.id->Float.toString} isEditing updateSite index>
      <div
        role="button"
        ariaLabel={`delete-site-${site.title}-btn`}
        onClick=onDelete
        className={`absolute ${pos} size-8 lg:size-10 2xl:size-12 center rounded-bl-box`}>
        <Solid.TrashIcon className="text-error resp-icon" />
      </div>
      {page.sites->Array.length > 1
        ? <MoveSiteButtons onMoveLeft onMoveRight title=site.title />
        : React.null}
    </SiteCard>
  })

  <React.Fragment>
    <div className="grid grid-cols-12 gap-4 lg:gap-6 xl:gap-8 2xl:gap-12 w-full animate-fade">
      {React.array(cards)}
    </div>
    <AddSiteButton addSite />
  </React.Fragment>
}
