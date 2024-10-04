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
    addPage: Page.t => unit,
    updatePage: Page.t => unit,
  }
}

module AppStore = Zustand.MakeStore(StoreData)

module Store = {
  let store = AppStore.create(set => {
    title: "Undoo Startpage",
    pages: Page.defaultPages,
    updateTitle: title => set(.state => {...state, title}),
    deletePage: id => set(.state => {...state, pages: state.pages->Array.filter(p => p.id != id)}),
    addPage: page => set(.state => {...state, pages: state.pages->Array.concat([page])}),
    updatePage: page =>
      set(.state => {
        ...state,
        pages: state.pages->Array.map(p => p.id == page.id ? page : p),
      }),
  })

  let use = _ => store->AppStore.use(state => state)
}
