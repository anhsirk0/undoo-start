@react.component
let make = () => {
  let {options} = Store.Bg.use()

  options.image->String.length > 20
    ? <React.Fragment>
        <figure className="absolute inset-0 transitional">
          <img className="h-full w-full object-cover" src=options.image alt="bg" />
        </figure>
        <div
          className="h-full w-full absolute inset-0"
          style={backgroundColor: Utils.getBgcolor(options.bgOpacity)}
        />
      </React.Fragment>
    : React.null
}
