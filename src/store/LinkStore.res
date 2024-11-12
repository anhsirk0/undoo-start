open Zustand
open Link

module StoreData = {
  type state = {
    links: array<Link.t>,
    addLink: Link.t => unit,
    updateLink: Link.t => unit,
  }
}

module AppStore = Zustand.MakeStore(StoreData)

module LinkStore = {
  let store = AppStore.create(AppStore.persist(set => {
      links: [],
      addLink: link => set(.state => {...state, links: state.links->Array.concat([link])}),
      updateLink: link =>
        set(.state => {
          ...state,
          links: state.links->Array.map(l => l.id == link.id ? link : l),
        }),
    }, {name: "undoo-links"}))

  let use = _ => store->AppStore.use(state => state)
}
