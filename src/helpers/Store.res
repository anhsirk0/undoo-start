include Page

module Zustand = {
  module type StoreConfig = {
    type state
  }

  module MakeStore = (Config: StoreConfig) => {
    type set = (. Config.state => Config.state) => unit
    type selector<'a> = Config.state => 'a

    type store

    external unsafeStoreToAny: store => 'a = "%identity"

    let use = (store: store, selector: selector<'a>): 'a => unsafeStoreToAny(store)(. selector)

    @module("zustand")
    external create: (set => Config.state) => store = "create"
  }
}

module StoreData = {
  type state = {
    title: string,
    pages: array<Page.t>,
    updateTitle: string => unit,
    deletePage: int => unit,
  }
}

module AppStore = Zustand.MakeStore(StoreData)

module Store = {
  let store = AppStore.create(set => {
    title: "Undoo Startpage",
    pages: Page.defaultPages,
    updateTitle: title => set(.state => {...state, title}),
    deletePage: id => set(.state => {...state, pages: Array.filter(state.pages, p => p.id != id)}),
  })

  let use = _ => store->AppStore.use(state => state)
}
