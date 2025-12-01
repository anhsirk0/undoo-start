@react.component
let make = (~isOpen, ~onClose) => {
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

  isOpen
    ? <Modal title="Themes" onClose classes="min-w-[60vw]">
        <ul className="grid grid-cols-10 gap-4 min-h-0 overflow-y-auto">
          {Config.themes
          ->Array.map(theme => {
            <ThemeCard theme onChange key=theme>
              <div
                className="flex flex-row rounded-box bg-base-100 border-4 border-neutral relative cursor-pointer">
                <div className="w-8 min-h-[100%] bg-neutral" />
                <div className="flex flex-col grow p-4">
                  <p className="title font-bold"> {theme->Utils.capitalize->React.string} </p>
                  <div
                    className="flex flex-row gap-1 rounded-btn [&>div]:h-6 [&>div]:w-2 [&>div]:rounded-box">
                    <div className="bg-primary" />
                    <div className="bg-accent" />
                    <div className="bg-secondary" />
                    <div className="bg-neutral" />
                  </div>
                  {currentTheme == theme
                    ? <Icon.sparkle
                        className="size-4 text-neutral-content absolute top-1 left-1 animate-grow"
                      />
                    : React.null}
                </div>
              </div>
            </ThemeCard>
          })
          ->React.array}
        </ul>
      </Modal>
    : React.null
}
