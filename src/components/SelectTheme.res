@module("../themes") external themes: array<string> = "default"

open Heroicons

@react.component
let make = () => {
  let themeCards = Array.map(themes, theme =>
    <ThemeCard theme key={theme}>
      <div className="flex flex-row gap-1 rounded-btn [&>div]:h-6 [&>div]:w-2 [&>div]:rounded-xl">
        <div className="bg-primary" />
        <div className="bg-accent" />
        <div className="bg-secondary" />
        <div className="bg-neutral" />
      </div>
    </ThemeCard>
  )

  <div className="dropdown dropdown-top dropdown-right">
    <div role="button" tabIndex={0} className="btn h-20 w-full btn-primary xxl:text-xl">
      <Solid.ColorSwatchIcon className="w-8 h-8" />
    </div>
    <ul
      className="dropdown-content z-[1] flex flex-col gap-2 p-4 bg-accent rounded-box h-96 min-h-0 overflow-y-auto mb-4 w-56 shadow-xl">
      {React.array(themeCards)}
    </ul>
  </div>
}
