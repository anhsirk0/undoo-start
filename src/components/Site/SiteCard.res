open Store
open Utils
open Site
open Hooks
open Heroicons

module LabelIcon = {
  @react.component
  let make = (~site: Site.t) => {
    let lightColor = Utils.isDarkMode() ? "text-base-content" : "text-base-100"
    let darkColor = Utils.isDarkMode() ? "text-base-100" : "text-base-content"

    let textColor =
      site.bgcolor
      ->Option.map(Utils.hex2value)
      ->Option.map(v => v < 0.5 ? lightColor : darkColor)
      ->Option.getOr(darkColor)

    <div
      className="absolute inset-0 size-full bg-primary center"
      style={backgroundColor: site.bgcolor->Option.getOr("#fff")}>
      <p className={`text-4xl font-bold ${textColor} group-hover:scale-105 transitional`}>
        {React.string(site.icon)}
      </p>
    </div>
  }
}

module SiteLabel = {
  @react.component
  let make = (~title: string, ~show: bool, ~circleIcons: bool) => {
    let radius = circleIcons ? "" : " rounded-box"
    show
      ? <div className="center absolute bottom-1 xxl:bottom-1.5 w-full h-[1.38rem] xxl:h-8">
          <div className={`center px-2 w-[90%] h-full bg-base-100/70 ${radius}`}>
            <p className="title truncate -mt-0.5 xxl:-mt-1"> {React.string(title)} </p>
          </div>
        </div>
      : React.null
  }
}

@react.component
let make = (~site: Site.t, ~isEditing, ~updateSite, ~children, ~index) => {
  let {options} = Store.use()
  let (isOpen, toggleOpen, _) = Hooks.useToggle()

  let isIconUrl = Utils.startsWith(site.icon, ["http", "/src", "/assets", "data:image"])
  let target = options.openLinkInNewTab ? "_blank" : "_self"

  let cardSize = "w-24 size-24 md:size-28 lg:size-28 xl:size-32 xxl:size-40"
  let radius = options.circleIcons ? "rounded-full" : ""

  <React.Fragment>
    <div
      onContextMenu=JsxEvent.Mouse.stopPropagation
      className="col-span-6 xs:col-span-4 md:col-span-3 lg:col-span-2 animate-grow animate-fade relative">
      <div
        id={"site-" ++ site.id->Int.toString}
        className={`card w-full isolate has-[a:active]:animate-shake overflow-hidden mx-auto ${cardSize} ${radius}`}>
        <a href=site.url target className="relative size-full group cursor-pointer">
          {isIconUrl
            ? <img
                className="size-full object-cover absolute inset-0 -z-1 group-hover:scale-105 transitional scale-[1.02]"
                src=site.icon
                alt=site.title
                style={backgroundColor: site.bgcolor->Option.getOr("#fff")}
              />
            : <LabelIcon site />}
          <SiteLabel title=site.title show=site.showLabel circleIcons=options.circleIcons />
        </a>
        {switch index {
        | Some(idx) =>
          <div
            className="bg-base-100/80 absolute top-0 left-0 size-6 lg:size-6 xl:size-8 center rounded-br-box animate-fade">
            <p className="resp-text xxl:text-2xl -ml-1/2 -mt-1/2 xxl:-ml-1 xxl:-mt-1">
              {React.string(idx->String.fromCharCode)}
            </p>
          </div>
        | None => React.null
        }}
        {isEditing
          ? <div
              role="button"
              ariaLabel={`edit-site-${site.title}-btn`}
              onClick={_ => toggleOpen()}
              className="bg-base-100/70 absolute inset-0 size-full center animate-fade">
              <Solid.PencilIcon className="size-8 xxl:size-10 text-base-content" />
              {children}
            </div>
          : React.null}
      </div>
    </div>
    {isOpen ? <EditSiteModal site updateSite onClose=toggleOpen /> : React.null}
  </React.Fragment>
}
