include Store
include Document

module Hooks = {
  let useDocTitle = (page: option<Page.t>) => {
    let store = Store.use()

    let title = switch page->Option.filter(_ => store.showPageTitle) {
    | Some(p) => `${p.title} - ${store.title}`
    | None => store.title
    }

    React.useEffectOnEveryRender(() => {
      open! Document
      document->setTitle(title)
      None
    })
  }
}
