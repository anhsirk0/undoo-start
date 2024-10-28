open Heroicons
open Store

@react.component
let make = (~onMoveLeft, ~onMoveRight, ~title) => {
  let {options} = Store.use()
  let leftPos = options.circleIcons ? "left-6 xxl:left-8" : "left-0"
  let rightPos = options.circleIcons ? "right-6 xxl:right-8" : "right-0"

  <React.Fragment>
    <div
      role="button"
      ariaLabel={`move-left-site-${title}-btn`}
      onClick=onMoveLeft
      className={`absolute bottom-0 ${leftPos} size-8 xxl:size-10 center resp-text`}>
      <Solid.ArrowLeftIcon className="resp-icon text-base-content" />
    </div>
    <div
      role="button"
      ariaLabel={`move-right-site-${title}-btn`}
      onClick=onMoveRight
      className={`absolute bottom-0 ${rightPos} size-8 xxl:size-10 center resp-text`}>
      <Solid.ArrowRightIcon className="resp-icon text-base-content" />
    </div>
  </React.Fragment>
}
