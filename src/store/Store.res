open Page
open Zustand

module AppOptions = {
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
    useLinks: true,
    hideEditButton: false,
    hideAddButton: false,
    alwaysShowHints: false,
    openLinkInNewTab: true,
    circleIcons: false,
  }
}

module StoreData = {
  type state = {
    options: AppOptions.t,
    searchEngineId: int,
    updateSearchEngineId: int => unit,
    pages: array<Page.t>,
    deletePage: int => unit,
    addPage: Page.t => unit,
    updatePage: Page.t => unit,
    updateOptions: AppOptions.t => unit,
  }
}

module AppStore = Zustand.MakeStore(StoreData)

module Store = {
  let store = AppStore.create(AppStore.persist(set => {
      options: AppOptions.defaultOptions,
      updateOptions: options => set(.state => {...state, options}),
      searchEngineId: 0,
      updateSearchEngineId: id => set(.state => {...state, searchEngineId: id}),
      pages: Page.defaultPages,
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
