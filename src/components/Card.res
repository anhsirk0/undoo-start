// @module("../../themes") external themes: array<string> = "default"

@react.component
let make = () => {
  <div className="card bg-primary/10 w-full min-h-48">
    <div className="card-body">
      <p className="card-title"> {React.string("this is card")} </p>
      <div className="text-lg"> {React.string("this is card body")} </div>
    </div>
  </div>
}
