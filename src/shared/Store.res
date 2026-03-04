module View = {
  module StoreData = {
    type state = {
      isEditing: bool,
      isVisiting: bool,
      view: Shape.View.t,
      setView: Shape.View.t => unit,
      setIsEditing: bool => unit,
      toggleEditing: unit => unit,
      setIsVisiting: bool => unit,
    }
  }

  module Store = Zustand.MakeStore(StoreData)

  let store = Store.create(set => {
    view: Loading,
    setView: view => set(state => {...state, view}),
    isEditing: false,
    isVisiting: false,
    setIsEditing: isEditing => set(state => {...state, isEditing}),
    setIsVisiting: isVisiting => set(state => {...state, isVisiting}),
    toggleEditing: () => set(state => {...state, isEditing: !state.isEditing}),
  })

  let use = _ => store->Store.use(state => state)
  let useShallow = selector => store->Store.use(Store.useShallow(selector))
}

module Options = {
  type t = {
    title: string,
    showPageTitle: bool,
    hideEditButton: bool,
    hideAddButton: bool,
    alwaysShowHints: bool,
    alwaysShowSidebar: bool,
    openLinkInNewTab: bool,
    circleIcons: bool,
    reverseBookmarksOrder: bool,
  }

  let defaultOptions = {
    title: "Undoo Startpage",
    showPageTitle: true,
    hideEditButton: false,
    hideAddButton: false,
    alwaysShowHints: false,
    alwaysShowSidebar: true,
    openLinkInNewTab: true,
    circleIcons: false,
    reverseBookmarksOrder: false,
  }
  module StoreData = {
    type state = {
      options: t,
      searchEngineIdx: int,
      updateSearchEngineIdx: int => unit,
      pages: array<Shape.Page.t>,
      addPage: Shape.Page.t => unit,
      updatePage: Shape.Page.t => unit,
      setPages: array<Shape.Page.t> => unit,
      updateOptions: t => unit,
    }
  }
  module Store = Zustand.MakeStore(StoreData)

  let store = Store.create(Store.persist(set => {
      options: defaultOptions,
      updateOptions: options => set(state => {...state, options}),
      searchEngineIdx: 0,
      updateSearchEngineIdx: idx => set(state => {...state, searchEngineIdx: idx}),
      // pages: Shape.Page.defaultPages,
      pages: [],
      addPage: page => set(state => {...state, pages: state.pages->Array.concat([page])}),
      updatePage: page =>
        set(state => {
          ...state,
          pages: state.pages->Array.map(p => p.id == page.id ? page : p),
        }),
      setPages: pages => set(state => {...state, pages}),
    }, {name: "undoo-startpage"}))

  let use = _ => store->Store.use(state => state)
  let useShallow = selector => store->Store.use(Store.useShallow(selector))
}

module Bg = {
  module StoreData = {
    type options = {
      image: string,
      imageName: string,
      bgOpacity: int,
      bookmarkOpacity: int,
      searchOpacity: int,
      searcherOpacity: int,
      // sidebarOpacity: int,
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
      bookmarkOpacity: 80,
      searchOpacity: 80,
      searcherOpacity: 80,
      // sidebarOpacity: 50,
    }
  }

  module Store = Zustand.MakeStore(StoreData)

  let store = Store.create(Store.persist(set => {
      options: StoreData.defaultOptions,
      update: options => set(state => {...state, options}),
      removeImage: () =>
        set(state => {...state, options: {...state.options, imageName: "", image: ""}}),
    }, {name: "undoo-background"}))

  let use = _ => store->Store.use(state => state)
  let useShallow = selector => store->Store.use(Store.useShallow(selector))
}

module Searcher = {
  module StoreData = {
    type state = {
      checkedIds: array<float>,
      engines: array<Shape.SearchEngine.t>,
      setEngines: array<Shape.SearchEngine.t> => unit,
      addEngine: Shape.SearchEngine.t => unit,
      updateEngine: Shape.SearchEngine.t => unit,
      deleteEngine: float => unit,
      toggleAll: bool => unit,
      toggleOne: (float, bool) => unit,
    }
  }

  module Store = Zustand.MakeStore(StoreData)

  let store = Store.create(Store.persist(set => {
      checkedIds: [0., 1.],
      engines: Shape.SearchEngine.defaultEngines,
      setEngines: engines => set(state => {...state, engines}),
      addEngine: engine => set(state => {...state, engines: state.engines->Array.concat([engine])}),
      updateEngine: engine =>
        set(state => {
          ...state,
          engines: state.engines->Array.map(e => e.id == engine.id ? engine : e),
        }),
      deleteEngine: id =>
        set(state => {...state, engines: state.engines->Array.filter(e => e.id != id)}),
      toggleOne: (id, exists) =>
        set(state => {
          ...state,
          checkedIds: exists
            ? state.checkedIds->Array.filter(i => i != id)
            : state.checkedIds->Array.concat([id]),
        }),
      toggleAll: all =>
        set(state => {...state, checkedIds: all ? [] : state.engines->Array.map(e => e.id)}),
    }, {name: "undoo-searcher"}))

  let use = _ => store->Store.use(state => state)
  let useShallow = selector => store->Store.use(Store.useShallow(selector))
}

module SearchEngine = {
  module StoreData = {
    type state = {
      engines: array<Shape.SearchEngine.t>,
      setEngines: array<Shape.SearchEngine.t> => unit,
      addEngine: Shape.SearchEngine.t => unit,
      updateEngine: Shape.SearchEngine.t => unit,
      deleteEngine: float => unit,
    }
  }

  module Store = Zustand.MakeStore(StoreData)

  let store = Store.create(Store.persist(set => {
      engines: Shape.SearchEngine.defaultEngines,
      setEngines: engines => set(state => {...state, engines}),
      addEngine: engine => set(state => {...state, engines: state.engines->Array.concat([engine])}),
      updateEngine: engine =>
        set(state => {
          ...state,
          engines: state.engines->Array.map(e => e.id == engine.id ? engine : e),
        }),
      deleteEngine: id =>
        set(state => {...state, engines: state.engines->Array.filter(e => e.id != id)}),
    }, {name: "undoo-search-engines"}))

  let use = _ => store->Store.use(state => state)
  let useShallow = selector => store->Store.use(Store.useShallow(selector))
}
