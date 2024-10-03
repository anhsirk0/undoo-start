open Heroicons

@react.component
let make = () => {
  let (isAdding, setIsAdding) = React.useState(_ => false)

  <React.Fragment>
    <button
      onClick={_ => setIsAdding(val => !val)}
      className={`btn animate-grow sidebar-btn ${isAdding ? "btn-accent" : "btn-ghost"}`}>
      <Solid.PlusIcon className="resp-icon" />
    </button>
  </React.Fragment>
}
