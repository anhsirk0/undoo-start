open Heroicons

@react.component
let make = (~link: Shape.Link.t) => {
  let store = Store.Options.use()
  let {deleteLink} = Store.Link.use()
  let (isEditing, setIsEditing) = React.useState(_ => false)

  let stopEvent = evt => {
    evt->ReactEvent.Mouse.stopPropagation
    evt->ReactEvent.Mouse.preventDefault
  }

  let toggleEditing = evt => {
    evt->stopEvent
    setIsEditing(val => !val)
  }
  let target = store.options.openLinkInNewTab ? "_blank" : "_self"

  let onDelete = evt => {
    evt->stopEvent
    deleteLink(link.id)
  }

  isEditing
    ? <AddLinkForm link />
    : <a
        onContextMenu=ReactEvent.Mouse.stopPropagation
        href=link.url
        target
        className="col-span-12 md:col-span-6 lg:col-span-4 group relative">
        <div
          className="flex flex-row rounded-btn bg-neutral text-neutral-content h-8 2xl:h-12 items-center">
          <img
            alt=link.title
            src={"https://t3.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=" ++
            link.url}
            className="h-full p-2 2xl:p-3 rounded-full"
          />
          <p className="truncate grow"> {link.title->React.string} </p>
          <div
            onClick={stopEvent}
            className="absolute top-0 right-0 hidden group-hover:flex 2xl:p-2 h-full bg-neutral rounded-btn">
            <button onClick=toggleEditing className="btn btn-sm btn-circle btn-ghost">
              <Solid.PencilIcon className="resp-icon" />
            </button>
            <button onClick=onDelete className="btn btn-sm btn-circle btn-ghost">
              <Solid.TrashIcon className="resp-icon text-error" />
            </button>
          </div>
        </div>
      </a>
}
