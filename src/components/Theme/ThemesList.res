open Heroicons

@react.component
let make = () => {
  let (currentTheme, setCurrrentTheme) = React.useState(_ => Utils.getTheme())

  let onChange = theme => {
    theme->Utils.setTheme
    setCurrrentTheme(_ => theme)
  }

  React.useEffect0(() => {
    currentTheme->Utils.setTheme
    None
  })

  React.useEffectOnEveryRender(() => {
    setCurrrentTheme(_ => Utils.getTheme())
    None
  })

  let themeCards = Array.map(Themes.themes, theme =>
    <ThemeCard theme onChange key=theme>
      {React.string(theme)}
      <div className="flex flex-row gap-1 rounded-btn [&>div]:h-6 [&>div]:w-2">
        <div className="bg-primary" />
        <div className="bg-accent" />
        <div className="bg-secondary" />
        <div className="bg-neutral" />
      </div>
      {currentTheme == theme
        ? <Solid.PaperClipIcon className="size-6 absolute -top-2 left-3" />
        : React.null}
    </ThemeCard>
  )

  {React.array(themeCards)}
}
