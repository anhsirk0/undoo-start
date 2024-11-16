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

module Options = {
  type t = {
    title: string,
    showPageTitle: bool,
    useSearcher: bool,
    useLinks: bool,
    hideEditButton: bool,
    hideAddButton: bool,
    alwaysShowHints: bool,
    openLinkInNewTab: bool,
    circleIcons: bool,
  }

  let defaultOptions = {
    title: "Undoo Startpage",
    showPageTitle: true,
    useSearcher: true,
    useLinks: false,
    hideEditButton: false,
    hideAddButton: false,
    alwaysShowHints: false,
    openLinkInNewTab: true,
    circleIcons: false,
  }
  module StoreData = {
    type state = {
      options: t,
      searchEngineId: int,
      updateSearchEngineId: int => unit,
      pages: array<Shape.Page.t>,
      deletePage: int => unit,
      addPage: Shape.Page.t => unit,
      updatePage: Shape.Page.t => unit,
      updateOptions: t => unit,
    }
  }
  module AppStore = Zustand.MakeStore(StoreData)

  let store = AppStore.create(AppStore.persist(set => {
      options: defaultOptions,
      updateOptions: options => set(.state => {...state, options}),
      searchEngineId: 0,
      updateSearchEngineId: id => set(.state => {...state, searchEngineId: id}),
      pages: Shape.Page.defaultPages,
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

module Bg = {
  module StoreData = {
    type options = {
      image: string,
      imageName: string,
      bgOpacity: int,
      searcherOpacity: int,
      searchOpacity: int,
      sidebarOpacity: int,
    }
    type state = {
      options: options,
      update: options => unit,
      removeImage: unit => unit,
    }

    let defaultOptions = {
      image: "",
      imageName: "",
      bgOpacity: 50,
      searcherOpacity: 80,
      searchOpacity: 80,
      sidebarOpacity: 50,
    }
  }

  module AppStore = Zustand.MakeStore(StoreData)

  let store = AppStore.create(AppStore.persist(set => {
      options: StoreData.defaultOptions,
      update: options => set(.state => {...state, options}),
      removeImage: () =>
        set(.state => {...state, options: {...state.options, imageName: "", image: ""}}),
    }, {name: "undoo-background"}))

  let use = _ => store->AppStore.use(state => state)
}

module Searcher = {
  module StoreData = {
    type state = {
      checkedIds: array<int>,
      engines: array<Shape.SearchEngine.t>,
      addEngine: Shape.SearchEngine.t => unit,
      updateEngine: Shape.SearchEngine.t => unit,
      deleteEngine: int => unit,
      toggleAll: bool => unit,
      toggleOne: (int, bool) => unit,
    }
  }

  module AppStore = Zustand.MakeStore(StoreData)

  let store = AppStore.create(AppStore.persist(set => {
      checkedIds: [0, 1],
      engines: Shape.SearchEngine.defaultEngines,
      addEngine: engine =>
        set(.state => {...state, engines: state.engines->Array.concat([engine])}),
      updateEngine: engine =>
        set(.state => {
          ...state,
          engines: state.engines->Array.map(e => e.id == engine.id ? engine : e),
        }),
      deleteEngine: id =>
        set(.state => {...state, engines: state.engines->Array.filter(e => e.id != id)}),
      toggleOne: (id, exists) =>
        set(.state => {
          ...state,
          checkedIds: exists
            ? state.checkedIds->Array.filter(i => i != id)
            : state.checkedIds->Array.concat([id]),
        }),
      toggleAll: all =>
        set(.state => {...state, checkedIds: all ? [] : state.engines->Array.map(e => e.id)}),
    }, {name: "undoo-searcher"}))

  let use = _ => store->AppStore.use(state => state)
}

module Link = {
  module StoreData = {
    type state = {
      links: array<Shape.Link.t>,
      addLink: Shape.Link.t => unit,
      updateLink: Shape.Link.t => unit,
      deleteLink: int => unit,
    }
  }

  module AppStore = Zustand.MakeStore(StoreData)
  let store = AppStore.create(AppStore.persist(set => {
      links: [],
      addLink: link => set(.state => {...state, links: state.links->Array.concat([link])}),
      updateLink: link =>
        set(.state => {
          ...state,
          links: state.links->Array.map(l => l.id == link.id ? link : l),
        }),
      deleteLink: id =>
        set(.state => {
          ...state,
          links: state.links->Array.filter(l => l.id != id),
        }),
    }, {name: "undoo-links"}))

  let use = _ => store->AppStore.use(state => state)
}
