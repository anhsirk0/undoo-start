include Site
open Heroicons

module DeletButton = {
  @react.component
  let make = (~onDelete) => {
    <div
      role="button"
      onClick=onDelete
      className="bg-error/60 absolute top-0 right-0 size-8 lg:size-10 xxl:size-12 center resp-text rounded-bl-box">
      <Solid.TrashIcon className="resp-icon text-base-content" />
    </div>
  }
}

@react.component
let make = (~site: Site.t, ~isEditing, ~onDelete, ~updateSite) => {
  let (isOpen, setIsOpen) = React.useState(_ => false)
  let toggleOpen = _ => setIsOpen(val => !val)

  let isIconUrl = Site.startsWith(site.icon, ["http", "/src", "/assets"])

  <React.Fragment>
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
                <img
                  className="h-full w-full object-cover card-image" src=site.icon alt=site.title
                />
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
        {isEditing
          ? <div
              role="button"
              onClick=toggleOpen
              className="bg-base-100/80 absolute inset-0 size-full center animate-fade">
              <DeletButton onDelete />
              <Solid.PencilIcon className="w-12 h-12 text-base-content" />
            </div>
          : React.null}
      </div>
    </div>
    {isOpen ? <EditSiteModal site updateSite onClose=toggleOpen /> : React.null}
  </React.Fragment>
}
