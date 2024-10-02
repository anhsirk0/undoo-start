@module("../themes") external themes: array<string> = "default"
@module("../helpers/setTheme") external setTheme: string => unit = "default"

@react.component
let make = () => {
  React.useEffect(() => {
    // Run effects
    let theme = Dom.Storage2.getItem(Dom.Storage2.localStorage, "undooStartpageTheme")
    switch theme {
    | Some(theme) => setTheme(theme)
    | None => Js.log("theme not found")
    }

    None // or Some(() => {})
  }, [])

  let themeCards = Array.map(themes, theme =>
    <ThemeCard theme key=theme>
      <div className="flex flex-row gap-1 rounded-btn [&>div]:h-6 [&>div]:w-2 [&>div]:rounded-xl">
        <div className="bg-primary" />
        <div className="bg-accent" />
        <div className="bg-secondary" />
        <div className="bg-neutral" />
      </div>
    </ThemeCard>
  )

  {React.array(themeCards)}
}
