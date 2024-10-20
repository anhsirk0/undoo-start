include Page
include Zustand

module StoreData = {
  type state = {
    title: string,
    openLinkInNewTab: bool,
    showPageTitle: bool,
    useSearcher: bool,
    searchEngineId: int,
    updateSearchEngineId: int => unit,
    pages: array<Page.t>,
    deletePage: int => unit,
    addPage: Page.t => unit,
    updatePage: Page.t => unit,
    updateOptions: (
      ~title: string,
      ~showPageTitle: bool,
      ~useSearcher: bool,
      ~openLinkInNewTab: bool,
    ) => unit,
  }
}

module AppStore = Zustand.MakeStore(StoreData)

module Store = {
  let store = AppStore.create(AppStore.persist(set => {
      title: "Undoo Startpage",
      showPageTitle: true,
      useSearcher: true,
      openLinkInNewTab: true,
      updateOptions: (
        ~title: string,
        ~showPageTitle: bool,
        ~useSearcher: bool,
        ~openLinkInNewTab: bool,
      ) => set(.state => {...state, title, showPageTitle, useSearcher, openLinkInNewTab}),
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
