let useDocTitle = (title: option<string>) => {
  let store = Store.Options.use()

  let docTitle = switch title->Option.filter(_ => store.options.showPageTitle) {
  | Some(title) => `${title} - ${store.options.title}`
  | None => store.options.title
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
