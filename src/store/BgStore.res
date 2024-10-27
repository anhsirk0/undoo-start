open Zustand

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

module BgStore = {
  let store = AppStore.create(AppStore.persist(set => {
      options: StoreData.defaultOptions,
      update: options => set(.state => {...state, options}),
      removeImage: () =>
        set(.state => {...state, options: {...state.options, imageName: "", image: ""}}),
    }, {name: "undoo-background"}))

  let use = _ => store->AppStore.use(state => state)
}
