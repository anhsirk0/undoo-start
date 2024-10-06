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

    type createFnParam = set => Config.state
    type persistOptions = {name: string}

    @module("zustand")
    external create: createFnParam => store = "create"
    @module("zustand/middleware")
    external persist: (createFnParam, persistOptions) => createFnParam = "persist"
  }
}

module StoreData = {
  type state = {
    title: string,
    searchEngineId: int,
    updateSearchEngineId: int => unit,
    pages: array<Page.t>,
    updateTitle: string => unit,
    deletePage: int => unit,
    addPage: Page.t => unit,
    updatePage: Page.t => unit,
  }
}

module AppStore = Zustand.MakeStore(StoreData)

module Store = {
  let store = AppStore.create(AppStore.persist(set => {
      title: "Undoo Startpage",
      searchEngineId: 0,
      updateSearchEngineId: id => set(.state => {...state, searchEngineId: id}),
      pages: Page.defaultPages,
      updateTitle: title => set(.state => {...state, title}),
      deletePage: id =>
        set(.state => {...state, pages: state.pages->Array.filter(p => p.id != id)}),
      addPage: page => set(.state => {...state, pages: state.pages->Array.concat([page])}),
      updatePage: page =>
        set(.state => {
          ...state,
          pages: state.pages->Array.map(p => p.id == page.id ? page : p),
        }),
    }, {name: "undoo-startpage"}))

  let use = _ => store->AppStore.use(state => state)
}
