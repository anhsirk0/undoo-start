include Store
open Heroicons

module Card = {
  @react.component
  let make = (~site: Site.t, ~isEditing, ~onDelete) => {
    let isIconUrl = Site.startsWith(site.icon, ["http", "/src", "/assets"])

    <div
      className="col-span-12 xs:col-span-6 sm:col-span-4 md:col-span-3 lg:col-span-2 animate-grow">
      <div
        className="card w-full h-24 md:h-28 lg:h-32 xl:h-36 xxl:h-48 overflow-hidden isolate shadow border border-base-200">
        <a
          href=site.url
          target="_blank"
          className="relative size-full group cursor-pointer relative">
          {isIconUrl
            ? <figure className="absolute inset-0 -z-10 group-hover:scale-105 transitional">
                <img className="h-full w-full object-cover" src=site.icon alt=site.title />
              </figure>
            : <div className="absolute inset-0 size-full bg-primary center">
                <p
                  className="text-4xl font-bold text-primary-content group-hover:scale-105 transitional">
                  {React.string(site.icon)}
                </p>
              </div>}
          {site.showLabel
            ? <div className="center p-4 bg-base-100/20 absolute bottom-0 h-12 w-full">
                <p className="title truncate"> {React.string(site.title)} </p>
              </div>
            : React.null}
        </a>
        {isEditing
          ? <div
              role="button"
              className="bg-base-100/80 absolute inset-0 size-full center animate-fade">
              <div
                onClick=onDelete
                className="bg-error/60 absolute top-0 right-0 size-8 lg:size-10 xxl:size-12 center resp-text rounded-bl-box">
                <Solid.TrashIcon className="resp-icon text-base-content" />
              </div>
              <Solid.PencilIcon className="w-12 h-12 text-base-content" />
            </div>
          : React.null}
      </div>
    </div>
  }
}

@react.component
let make = (~page: Page.t, ~isEditing) => {
  let store = Store.use()

  let cards = Array.map(page.sites, site => {
    let onDelete = evt => {
      JsxEvent.Mouse.stopPropagation(evt)
      store.updatePage({...page, sites: page.sites->Array.filter(s => s.id != site.id)})
      Js.log(site)
    }

    <Card site key={Int.toString(site.id)} isEditing onDelete />
  })

  <div className="grid grid-cols-12 gap-4 lg:gap-6 xl:gap-8 xxl:gap-12 w-full">
    {React.array(cards)}
  </div>
}