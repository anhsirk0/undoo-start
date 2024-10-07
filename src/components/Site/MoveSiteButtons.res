open Heroicons

@react.component
let make = (~onMoveLeft, ~onMoveRight, title) => {
  <React.Fragment>
    <div
      role="button"
      ariaLabel={`move-left-site-${title}-btn`}
      onClick=onMoveLeft
      className="absolute bottom-0 left-0 size-8 lg:size-10 xxl:size-12 center resp-text">
      <Solid.ArrowLeftIcon className="resp-icon text-base-content" />
    </div>
    <div
      role="button"
      ariaLabel={`move-right-site-${title}-btn`}
      onClick=onMoveRight
      className="absolute bottom-0 right-0 size-8 lg:size-10 xxl:size-12 center resp-text">
      <Solid.ArrowRightIcon className="resp-icon text-base-content" />
    </div>
  </React.Fragment>
}
