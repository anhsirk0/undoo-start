include Store
include Utils
open Heroicons

@react.component
let make = (~site: Site.t, ~isEditing, ~updateSite, ~children, ~index) => {
  let store = Store.use()
  let (isOpen, setIsOpen) = React.useState(_ => false)
  let toggleOpen = _ => setIsOpen(val => !val)

  let isIconUrl = Utils.startsWith(site.icon, ["http", "/src", "/assets", "data:image"])
  let target = store.openLinkInNewTab ? "_blank" : "_self"

  <React.Fragment>
    <div
      onContextMenu=JsxEvent.Mouse.stopPropagation
      className="col-span-12 xs:col-span-6 sm:col-span-4 md:col-span-3 lg:col-span-2 animate-grow animate-fade">
      <div
        id={"site-" ++ site.id->Int.toString}
        className="card w-full h-24 md:h-28 lg:h-32 xl:h-36 xxl:h-48 overflow-hidden isolate border border-base-200 has-[a:active]:animate-shake">
        <a href=site.url target className="relative size-full group cursor-pointer">
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
            ? <div className="center p-2 bg-base-100/80 absolute bottom-0 h-6 xxl:h-8 w-full">
                <p className="title font-bold truncate"> {React.string(site.title)} </p>
              </div>
            : React.null}
        </a>
        {switch index {
        | Some(idx) =>
          <div
            className="bg-base-100/80 absolute top-0 left-0 size-8 lg:size-10 xxl:size-12 center resp-text rounded-br-box animate-fade">
            {React.string(idx->String.fromCharCode)}
          </div>
        | None => React.null
        }}
        {isEditing
          ? <div
              role="button"
              ariaLabel={`edit-site-${site.title}-btn`}
              onClick=toggleOpen
              className="bg-base-100/80 absolute inset-0 size-full center animate-fade">
              <Solid.PencilIcon className="w-12 h-12 text-base-content" />
              {children}
            </div>
          : React.null}
      </div>
    </div>
    {isOpen ? <EditSiteModal site updateSite onClose=toggleOpen /> : React.null}
  </React.Fragment>
}
