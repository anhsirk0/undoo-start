include Icon

@react.component
let make = (~chosen, ~onChoose, ~isIconError) => {
  let icons =
    Site.defaultSites
    ->Array.concat(Site.localServers)
    ->Array.map(Icon.fromSite)
    ->Array.concat(Icon.icons)
    ->Array.map(icon => {
      let activeClass =
        chosen->Option.filter(src => src == icon.src)->Option.isSome ? "ring ring-accent" : ""

      <div
        key={icon.id->Int.toString}
        className={`col-span-2 cursor-pointer rounded-box ${activeClass}`}
        onClick={_ => onChoose(icon.src)}>
        <img
          src=icon.src
          alt=icon.title
          className="size-full object-cover rounded-box border border-base-200"
        />
      </div>
    })

  <React.Fragment>
    <p className="label"> {React.string("Choose Icon")} </p>
    {isIconError
      ? <p className="label text-error -mt-2">
          {React.string("Enter an icon url or choose from the following icons.")}
        </p>
      : React.null}
    <div className="grid grid-cols-12 flex-wrap gap-4 mt-4"> {React.array(icons)} </div>
  </React.Fragment>
}
