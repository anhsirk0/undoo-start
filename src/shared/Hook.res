let useDocTitle = (title: option<string>) => {
  let (showTitle, storeTitle) = Store.Options.useShallow(s => (
    s.options.showPageTitle,
    s.options.title,
  ))

  let docTitle = switch title->Option.filter(_ => showTitle) {
  | Some(title) => `${title} - ${storeTitle}`
  | None => storeTitle
  }

  React.useEffectOnEveryRender(() => {
    Document.document->Document.setTitle(docTitle)
    None
  })
}

let useToggle = (~init: bool=false) => {
  let (isOpen, setIsOpen) = React.useState(_ => init)
  let toggleOpen = () => setIsOpen(val => !val)
  (isOpen, toggleOpen, setIsOpen)
}
