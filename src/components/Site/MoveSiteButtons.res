open Heroicons

@react.component
let make = (~onMoveLeft, ~onMoveRight, ~title) => {
  let {options} = Store.Options.use()
  let leftPos = options.circleIcons ? "left-6 xxl:left-8" : "left-0"
  let rightPos = options.circleIcons ? "right-6 xxl:right-8" : "right-0"
  let class = "absolute bottom-0 size-8 xxl:size-10 center xl:text-2xl xxl:text-4xl"

  <React.Fragment>
    <div
      role="button"
      ariaLabel={`move-left-site-${title}-btn`}
      onClick=onMoveLeft
      className={`${class} ${leftPos}`}>
      <Solid.ArrowLeftIcon className="resp-icon text-base-content" />
    </div>
    <div
      role="button"
      ariaLabel={`move-right-site-${title}-btn`}
      onClick=onMoveRight
      className={`${class} ${rightPos}`}>
      <Solid.ArrowRightIcon className="resp-icon text-base-content" />
    </div>
  </React.Fragment>
}
