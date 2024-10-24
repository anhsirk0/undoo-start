include Document
open Store

module Hooks = {
  let useDocTitle = (title: option<string>) => {
    let store = Store.use()

    let docTitle = switch title->Option.filter(_ => store.options.showPageTitle) {
    | Some(title) => `${title} - ${store.options.title}`
    | None => store.options.title
    }

    React.useEffectOnEveryRender(() => {
      open! Document
      document->setTitle(docTitle)
      None
    })
  }
}
