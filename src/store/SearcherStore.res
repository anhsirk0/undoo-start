include Zustand
include SearchEngine

module StoreData = {
  type state = {
    checkedIds: array<int>,
    engines: array<SearchEngine.t>,
    addEngine: SearchEngine.t => unit,
    updateEngine: SearchEngine.t => unit,
    deleteEngine: int => unit,
    toggleAll: bool => unit,
    toggleOne: (int, bool) => unit,
  }
}

module AppStore = Zustand.MakeStore(StoreData)

module SearcherStore = {
  let store = AppStore.create(AppStore.persist(set => {
      checkedIds: [0, 1],
      engines: SearchEngine.defaultEngines,
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
