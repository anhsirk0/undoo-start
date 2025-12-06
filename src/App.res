open ReactEvent

@react.component
let make = () => {
  let store = Store.Options.use()
  let {view, setView, isEditing, toggleEditing, setIsVisiting} = Store.View.use()
  let firstView = () => store.pages->Shape.View.first

  let findPage = id => store.pages->Array.find(p => p.id == id)
  // let (view, setView) = React.useState(_ => store.pages->Array.length > 0 ? firstView() : Loading)
  let (query, setQuery) = React.useState(_ => "")

  let (isDebounced, setIsDebounced) = React.useState(_ => true)

  let afterDelete = pages => setView(pages->Shape.View.first)

  let onContextMenu = evt => {
    Mouse.preventDefault(evt)
    toggleEditing()
  }

  let onWheel = evt => {
    if isDebounced {
      setIsDebounced(_ => false)

      let deltaY = Wheel.deltaY(evt)->Float.toInt
      let nextView = switch view {
      | Page(pageId) => {
          let nextIdx =
            store.pages
            ->Array.findIndex(p => p.id == pageId)
            ->Utils.getNextIndex(store.pages->Array.length, deltaY)

          store.pages[nextIdx]
          ->Option.map(p => Shape.View.Page(p.id))
          ->Option.getOr(firstView())
        }
      // Todo: Enable scrolling through other views
      | Action(_) => firstView()
      | Loading => Loading
      }
      setView(nextView)

      let _ = setTimeout(_ => setIsDebounced(_ => true), 200)
    }
  }

  let onKeyDown = evt => {
    let isModifier = [Keyboard.ctrlKey, Keyboard.metaKey]->Array.some(fn => evt->fn)
    let key = Keyboard.key(evt)

    if !isModifier && key != "Tab" {
      Keyboard.preventDefault(evt)
      let digit = key->Int.fromString
      let isModalOpen = ReactDOM.querySelector(".modal-open")->Option.isSome

      if isModalOpen {
        if key == "Escape" {
          "#close-btn"->Utils.querySelectAndThen(Utils.click)
        }
      } else if key == " " {
        setIsVisiting(true)
        let _ = setTimeout(_ => setIsVisiting(false), 2000)
      } else if key == "/" {
        "input[name='query']"->Utils.querySelectAndThen(Utils.focus)
      } else if key == "?" {
        setView(Action(Searcher))
      } else if key == "-" {
        toggleEditing()
      } else if key == "=" || key == "+" {
        "#add-btn"->Utils.querySelectAndThen(Utils.click)
      } else if key == "." {
        "#options-btn"->Utils.querySelectAndThen(Utils.click)
      } else if key == "," {
        "#theme-btn"->Utils.querySelectAndThen(Utils.click)
      } else if digit->Option.isSome {
        switch digit->Option.filter(i => i > 0 && i <= store.pages->Array.length) {
        | Some(i) =>
          switch store.pages[i - 1] {
          | Some(p) => setView(Page(p.id))
          | None => ()
          }
        | None => ()
        }
      } else {
        let keyCode = Keyboard.keyCode(evt) - 65
        let site = switch view {
        | Page(id) => id->findPage->Option.flatMap(p => p.sites[keyCode])
        | _ => None
        }
        switch site {
        | Some(s) => {
            let id = "#site-" ++ s.id->Float.toString
            id->Utils.querySelectAndThen(el => {
              let _ = el->Utils.addClass("animate-shake")
              let _ = setTimeout(_ => el->Utils.removeClass("animate-shake"), 800)
            })
            let target = store.options.openLinkInNewTab ? "_blank" : "_self"
            switch s.url->Shape.Action.fromUrlString {
            | Some(Searcher) => setView(Action(Searcher))
            | Some(History) => setView(Action(Searcher))
            | Some(Bookmarks) => setView(Action(Bookmarks))
            | None => Utils.openUrl(s.url, target)
            }
          }
        | None => ()
        }
      }
    }
  }

  React.useEffect(() => {
    Document.addKeyListener("keydown", onKeyDown)
    Some(() => Document.removeKeyListener("keydown", onKeyDown))
  }, [view])

  React.useEffect0(() => {
    if store.pages->Array.length == 0 {
      Browser.getTopSites()
      ->Promise.then(async sites => {
        let pages =
          sites->Array.length > 0 ? sites->Shape.Page.fromTopSites : Shape.Page.defaultPages
        pages->store.setPages
        setTimeout(() => setView(pages->Shape.View.first), 100)
      })
      ->ignore
    } else {
      setView(firstView())
    }
    None
  })

  <div onContextMenu onWheel className="main flex-col p-8 relative">
    <Toast.Toaster />
    <BackgroundImage />
    {store.options.hideEditButton || view == Action(Bookmarks)
      ? React.null
      : <button
          ariaLabel="toggle-edit-mode-btn"
          onClick={_ => toggleEditing()}
          className={`fixed top-2 right-2 btn btn-circle btn-resp ${isEditing
              ? "btn-accent"
              : "btn-ghost"}`}
        >
          <Icon.pencil className="resp-icon" />
        </button>}
    <Sidebar />
    {switch view {
    | Loading => React.null
    | Page(id) =>
      switch id->findPage {
      | Some(page) => <PageView page key=page.title afterDelete query setQuery />
      | None => React.null
      }
    | Action(Searcher) => <Searcher query setQuery />
    | Action(Bookmarks) => <BookmarksView />
    // Todo: Implement History actions
    | Action(History) => React.null
    }}
  </div>
}
