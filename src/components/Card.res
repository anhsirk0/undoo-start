include Site

@react.component
let make = (~site: Site.t) => {
  let isIconUrl = String.startsWith(site.icon, "http") || String.startsWith(site.icon, "/src")
  <a
    href={site.url}
    target="_blank"
    className="card w-full h-28 lg:h-32 xl:h-36 xxl:h-48 relative overflow-hidden isolate shadow-xl group cursor-pointer">
    {isIconUrl
      ? <figure className="absolute inset-0 -z-10 group-hover:scale-105 transitional">
          <img className="h-full w-full object-cover" src={site.icon} alt={site.title} />
        </figure>
      : <div className="absolute inset-0 size-full bg-primary center">
          <p
            className="text-4xl font-bold text-primary-content group-hover:animate-bounce transitional">
            {React.string(site.icon)}
          </p>
        </div>}
    {site.showLabel
      ? <div className="center p-4 bg-base-100/20 absolute bottom-0 h-12 w-full">
          <p className="title truncate"> {React.string(site.title)} </p>
        </div>
      : React.null}
  </a>
}
