@react.component
let make = () => {
  let {options} = Store.Bg.use()
  let useBg = options.image->String.length > 20

  React.useEffectOnEveryRender(() => {
    if useBg {
      "#bg-overlay"->Utils.querySelectAndThen(Utils.setBg(_, options.bgOpacity))
      "#search-input"->Utils.querySelectAndThen(Utils.setBg(_, options.searchOpacity))
      "#search-btn"->Utils.querySelectAndThen(Utils.setBg(_, options.searchOpacity))
      "#searcher"->Utils.querySelectAndThen(Utils.setBg(_, options.searchOpacity))
      "#select-search-engine"->Utils.querySelectAndThen(Utils.setBg(_, options.searchOpacity))

      Document.querySelectorAll("[name=searcher-item]")->Array.forEach(
        Utils.setBg(_, options.searcherOpacity),
      )
    }
    None
  })

  useBg
    ? <React.Fragment>
        <figure className="absolute inset-0 transitional">
          <img className="h-full w-full object-cover" src=options.image alt="bg" />
        </figure>
        <div id="bg-overlay" className="h-full w-full absolute inset-0 bg-base-100/50" />
      </React.Fragment>
    : React.null
}
