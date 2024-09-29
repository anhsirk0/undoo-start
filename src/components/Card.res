// @module("../../themes") external themes: array<string> = "default"

@react.component
let make = () => {
  <div className="card w-full min-h-20 xxl:min-h-48 relative overflow-hidden isolate shadow-xl">
    <figure className="absolute inset-0 -z-10">
      <img
        className="h-full w-full object-clip"
        src="https://static.vecteezy.com/system/resources/previews/016/629/896/original/youtube-logo-on-black-background-free-vector.jpg"
        alt="Youtube"
      />
    </figure>
    <div className="center p-4 bg-primary/5 absolute bottom-0 h-12 w-full">
      <p className="title truncate"> {React.string("this is card this is card, this is card")} </p>
    </div>
  </div>
}
