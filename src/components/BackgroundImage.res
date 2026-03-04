@react.component
let make = () => {
  let (image, bgOpacity) = Store.Bg.useShallow(s => (s.options.image, s.options.bgOpacity))

  image->String.length > 20
    ? <React.Fragment>
        <figure className="absolute inset-0 transitional">
          <img className="h-full w-full object-cover" src=image alt="bg" />
        </figure>
        <div
          className="h-full w-full absolute inset-0"
          style={backgroundColor: bgOpacity->Utils.getBgcolor}
        />
      </React.Fragment>
    : React.null
}
