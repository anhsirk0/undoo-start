open Zustand
open Link

module StoreData = {
  type state = {
    links: array<Link.t>,
    addLink: Link.t => unit,
    updateLink: Link.t => unit,
    deleteLink: int => unit,
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
      deleteLink: id =>
        set(.state => {
          ...state,
          links: state.links->Array.filter(l => l.id != id),
        }),
    }, {name: "undoo-links"}))

  let use = _ => store->AppStore.use(state => state)
}
