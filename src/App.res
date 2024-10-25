include Store
include Utils
include Document

open Heroicons
open ReactEvent

@react.component
let make = () => {
  let store = Store.use()
  let (pageId, setPageId) = React.useState(_ => store.pages[0]->Option.map(p => p.id))
  let (isEditing, setIsEditing) = React.useState(_ => false)
  let (isVisiting, setIsVisiting) = React.useState(_ => false)
  let (isDebounced, setIsDebounced) = React.useState(_ => true)
  let page = pageId->Option.flatMap(id => store.pages->Array.find(p => p.id == id))
  let isSearching = pageId->Option.filter(id => id == -1)->Option.isSome

  let onContextMenu = evt => {
    setIsEditing(v => !v)
    Mouse.preventDefault(evt)
  }

  let onWheel = evt => {
    if isDebounced {
      setIsDebounced(_ => false)

      let deltaY = Wheel.deltaY(evt)->Float.toInt
      let nextPageId =
        pageId
        ->Option.map(id => store.pages->Array.findIndex(p => p.id == id))
        ->Option.map(index => index->Utils.getNextIndex(store.pages->Array.length, deltaY))
        ->Option.flatMap(index => store.pages[index])
        ->Option.map(p => p.id)

      setPageId(_ => nextPageId)

      let _ = setTimeout(_ => setIsDebounced(_ => true), 200)
    }
  }

  let onKeyDown = evt => {
    let isModifier = [Keyboard.ctrlKey, Keyboard.metaKey]->Array.some(fn => evt->fn)

    if !isModifier {
      let digit = Keyboard.key(evt)->Int.fromString
      if Keyboard.key(evt) == " " {
        setIsVisiting(_ => true)
        let _ = setTimeout(_ => setIsVisiting(_ => false), 2000)
      } else if Keyboard.key(evt) == "/" {
        Keyboard.preventDefault(evt)
        switch ReactDOM.querySelector("input[name='query'") {
        | Some(el) => el->Utils.focus
        | None => ()
        }
      } else if Keyboard.key(evt) == "?" {
        Keyboard.preventDefault(evt)
        setPageId(_ => Some(-1))
      } else if Keyboard.key(evt) == "-" {
        Keyboard.preventDefault(evt)
        setIsEditing(val => !val)
      } else if Keyboard.key(evt) == "=" || Keyboard.key(evt) == "+" {
        Keyboard.preventDefault(evt)
        switch ReactDOM.querySelector("#add-btn") {
        | Some(el) => el->Utils.click
        | None => ()
        }
      } else if digit->Option.isSome {
        switch digit->Option.filter(i => i > 0 && i <= store.pages->Array.length) {
        | Some(i) => setPageId(_ => store.pages[i - 1]->Option.map(p => p.id))
        | None => ()
        }
      } else {
        let keyCode = Keyboard.keyCode(evt) - 65
        let site = page->Option.flatMap(p => p.sites[keyCode])

        switch site {
        | Some(s) => {
            switch ReactDOM.querySelector("#site-" ++ s.id->Int.toString) {
            | Some(el) => {
                let _ = el->Utils.addClass("animate-shake")
                let _ = setTimeout(_ => el->Utils.removeClass("animate-shake"), 900)
              }
            | None => ()
            }

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
  }, [page])

  <div onContextMenu onWheel className="main flex-col p-8">
    {store.options.hideEditButton
      ? React.null
      : <button
          ariaLabel="toggle-edit-mode-btn"
          onClick={_ => setIsEditing(val => !val)}
          className={`fixed top-2 xxl:top-5 right-2 xxl:right-4 btn btn-circle btn-resp ${isEditing
              ? "btn-accent"
              : "btn-ghost"}`}>
          <Solid.PencilIcon className="resp-icon" />
        </button>}
    <Sidebar page setPageId isEditing isSearching />
    {isSearching ? <Searcher /> : <SearchBar />}
    <div
      onWheel={evt => {
        let target = Wheel.target(evt)
        if target["scrollHeight"] > target["clientHeight"] {
          Wheel.stopPropagation(evt)
        }
      }}
      className="grow main-width xxl:max-w-screen-xxl ml-12 p-4 lg:py-4 xxl:py-8 min-h-0 overflow-y-auto">
      {switch page {
      | Some(page) => <SiteCards page key=page.title isEditing isVisiting />
      | None => React.null
      }}
    </div>
  </div>
}
