open ReactEvent

@react.component
let make = () => {
  let store = Store.Options.use()
  let firstView = () => store.pages->Shape.View.first

  let findPage = id => store.pages->Array.find(p => p.id == id)
  let (view, setView) = React.useState(_ => store.pages->Array.length > 0 ? firstView() : Loading)
  let (query, setQuery) = React.useState(_ => "")

  let (isEditing, setIsEditing) = React.useState(_ => false)
  let (isVisiting, setIsVisiting) = React.useState(_ => false)
  let (isDebounced, setIsDebounced) = React.useState(_ => true)

  let afterDelete = pages => setView(_ => pages->Shape.View.first)

  let onContextMenu = evt => {
    setIsEditing(v => !v)
    Mouse.preventDefault(evt)
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
      | Searcher => firstView()
      | Loading => Loading
      }
      setView(_ => nextView)

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
        setIsVisiting(_ => true)
        let _ = setTimeout(_ => setIsVisiting(_ => false), 2000)
      } else if key == "/" {
        "input[name='query']"->Utils.querySelectAndThen(Utils.focus)
      } else if key == "?" {
        setView(_ => Searcher)
      } else if key == "-" {
        setIsEditing(val => !val)
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
          | Some(p) => setView(_ => Page(p.id))
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
            Utils.openUrl(s.url, target)
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
        setTimeout(() => setView(_ => pages->Shape.View.first), 100)
      })
      ->ignore
    }
    None
  })

  <div onContextMenu onWheel className="main flex-col p-8 relative">
    <Toast.Toaster />
    <BackgroundImage />
    {store.options.hideEditButton
      ? React.null
      : <button
          ariaLabel="toggle-edit-mode-btn"
          onClick={_ => setIsEditing(val => !val)}
          className={`fixed top-2 right-2 btn btn-circle btn-resp ${isEditing
              ? "btn-accent"
              : "btn-ghost"}`}>
          <Icon.pencil className="resp-icon" />
        </button>}
    <Sidebar view setView isEditing />
    {switch view {
    | Loading => React.null
    | Page(id) =>
      switch id->findPage {
      | Some(page) =>
        <PageView page key=page.title isEditing isVisiting afterDelete query setQuery />
      | None => React.null
      }
    | Searcher => <Searcher isEditing query setQuery />
    }}
  </div>
}
