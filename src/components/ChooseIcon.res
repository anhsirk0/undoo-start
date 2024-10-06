include Site

@react.component
let make = (~chosen, ~onChoose, ~isIconError) => {
  let icons = Site.defaultSites->Array.map(site => {
    let activeClass =
      chosen->Option.filter(icon => icon == site.icon)->Option.isSome ? "ring ring-accent" : ""

    <div
      key={site.id->Int.toString}
      className={`col-span-2 cursor-pointer rounded-box ${activeClass}`}
      onClick={_ => onChoose(site.icon)}>
      <img
        src=site.icon
        alt=site.title
        className="size-full object-cover rounded-box border border-base-200"
      />
    </div>
  })

  <React.Fragment>
    {isIconError
      ? <p className="label text-error -mt-2">
          {React.string("Enter an icon url or choose from the following icons.")}
        </p>
      : React.null}
    <div className="grid grid-cols-12 flex-wrap gap-4 mt-4"> {React.array(icons)} </div>
  </React.Fragment>
}
