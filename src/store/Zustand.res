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
