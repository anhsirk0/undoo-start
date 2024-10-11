include Store

module Document = {
  type t
  @val external document: t = "document"
  @set external setTitle: (t, string) => unit = "title"
}

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
