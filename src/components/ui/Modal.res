@react.component
let make = (~title, ~onClose, ~children) => {
  <div className="modal modal-open modal-bottom sm:modal-middle">
    <div className="modal-box flex flex-col max-h-[90vh] min-w-[36vw]">
      <div className="flex flex-row items-center justify-between mb-4 -mt-1">
        <p className="font-bold text-lg"> {React.string(title)} </p>
        <button onClick={_ => onClose()} className="btn btn-sm btn-circle btn-ghost -mt-2">
          {React.string(`✕`)}
        </button>
      </div>
      {children}
    </div>
  </div>
}
