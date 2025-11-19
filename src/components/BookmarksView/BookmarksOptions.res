let onBookmarkItem = (id, fn) => Utils.querySelectAndThen(`#bookmark-${id}`, fn)

@react.component
let make = (~item: Bookmarks.treeNode) => {
  let deleteBookmark = () => {
    onBookmarkItem(item.id, el => {
      if el->Utils.hasClass("hidden") {
        Js.log(`Bookmark "${item.title}" deleted`)
        Browser.removeBookmark(item.id)->ignore
      }
    })
  }

  let undoDelete = _ => {
    Toast.dismiss(item.id)
    onBookmarkItem(item.id, el => el->Utils.removeClass("hidden"))
  }

  let onDelete = _ => {
    onBookmarkItem(item.id, el => el->Utils.addClass("hidden"))
    setTimeout(deleteBookmark, 5500)->ignore

    Toast.custom(
      <div
        className="flex flex-row p-4 gap-4 rounded-box bg-success text-success-content animate-grow items-center">
        <p className="text-xl font-bold">
          {`Bookmark "${item.title}" deleted successfully`->React.string}
        </p>
        <button onClick=undoDelete className="btn"> {"Undo"->React.string} </button>
      </div>,
      Toast.Options.fromObj({"duration": 5000, "id": item.id}),
    )
  }

  <div className="dropdown dropdown-bottom dropdown-end">
    <button name="bookmark-options" tabIndex=0 className="btn btn-circle btn-ghost">
      <Icon.dotsThreeVertical className="resp-icon" />
    </button>
    <ul
      tabIndex=0
      className="dropdown-content z-20 mt-4 shadow bg-accent text-accent-content rounded-box menu [&>li>*:hover]:bg-base-100/20 ">
      <span className="flyout-arrow flyout-arrow-end" />
      // <li>
      //   <button id="open-note-info">
      //     <Icon.info className="resp-icon" />
      //     {"Info"->React.string}
      //   </button>
      // </li>
      <li>
        <button onClick=onDelete className="text-error font-bold">
          <Icon.trash className="resp-icon" weight="fill" />
          {"Delete"->React.string}
        </button>
      </li>
    </ul>
  </div>
}
