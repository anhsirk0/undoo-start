@val @scope("window")
external openUrl: (string, string) => unit = "open"

@send external focus: Dom.element => unit = "focus"
@send external click: Dom.element => unit = "click"
@send external blur: Dom.element => unit = "blur"
@send external setAttribute: (Dom.element, string, string) => unit = "setAttribute"
@set external setValue: (Dom.element, string) => unit = "value"
@get external getValue: Dom.element => string = "value"

let addClass = %raw(`function (el, cls) { el.classList.add(cls) }`)
let removeClass = %raw(`function (el, cls) { el.classList.remove(cls) }`)
let getCssVar = %raw(`function (name) { return getComputedStyle(document.body).getPropertyValue(name) }`)
let hasClass = %raw(`function (el, cls) { return el.classList.contains(cls) }`)

let isDarkMode = () => getCssVar("color-scheme") == "dark"

let querySelectAndThen = (selector, action) => {
  switch ReactDOM.querySelector(selector) {
  | Some(el) => el->action
  | None => ()
  }
}

type baseColor = [#100 | #200 | #300]
let getBgcolor = (opacity, ~base=#100) => {
  let opac = `${opacity->Int.toString}%`
  `color-mix(in oklab, var(--color-base-${base->String.make}) ${opac}, transparent)`
}

let getTheme = () => {
  open Dom.Storage
  switch "undooStartpageTheme"->getItem(localStorage) {
  | Some(theme) => theme
  | None => "cupcake"
  }
}
let setTheme = theme => {
  "html"->querySelectAndThen(setAttribute(_, "data-theme", theme))
  open Dom.Storage
  "undooStartpageTheme"->setItem(theme, localStorage)
}

let searchLink = (url, text, ~target="_blank") => {
  url
  ->String.replace("<Q>", encodeURI(text))
  ->openUrl(target)
}

let startsWith = (str, terms) => Array.some(terms, s => String.startsWith(str, s))

let moveLeft = (arr: array<'a>, index: int) => {
  if index == 0 {
    arr->Array.sliceToEnd(~start=1)->Array.concat(arr->Array.slice(~start=0, ~end=1))
  } else {
    arr
    ->Array.slice(~start=0, ~end=index - 1)
    ->Array.concatMany([
      arr->Array.slice(~start=index - 1, ~end=index + 1)->Array.toReversed,
      arr->Array.sliceToEnd(~start=index + 1),
    ])
  }
}

let moveRight = (arr: array<'a>, index: int) => {
  if index == arr->Array.length - 1 {
    arr->Array.sliceToEnd(~start=-1)->Array.concat(arr->Array.slice(~start=0, ~end=-1))
  } else {
    arr
    ->Array.slice(~start=0, ~end=index)
    ->Array.concatMany([
      arr->Array.slice(~start=index, ~end=index + 2)->Array.toReversed,
      arr->Array.sliceToEnd(~start=index + 2),
    ])
  }
}

let getNextIndex = (index, length, dir) => {
  if dir > 0 {
    mod(index + 1, length)
  } else if index > 0 {
    mod(index - 1, length)
  } else {
    length - 1
  }
}

let hex2value = hex => {
  let strToHexFloat = s => s->Int.fromString(~radix=16)->Option.getOr(0)->Int.toFloat
  let r = hex->String.substring(~start=1, ~end=3)->strToHexFloat
  let g = hex->String.substring(~start=3, ~end=5)->strToHexFloat
  let b = hex->String.substring(~start=5, ~end=7)->strToHexFloat

  let max = r->Math.max(g)->Math.max(b)
  max /. 255.
}

let newFileUrl: string => string = %raw(`function (text) {
 return URL.createObjectURL(new Blob([text], {type: "text/plain"}))
 }`)

let revokeObjectURL = %raw(`function (url) {
 window.URL.revokeObjectURL(url)
 }`)

let downloadJson = (data, title) => {
  let url = data->newFileUrl
  let a = "a"->Document.createElement
  a->setAttribute("href", url)
  a->setAttribute("download", `${title}.json`)
  let _ = Document.body->Document.appendChild(a)
  a->click
  let _ = setTimeout(() => {
    Document.body->Document.removeChild(a)
    url->revokeObjectURL
  }, 1)
}

let capitalize = str =>
  str->String.charAt(0)->String.toUpperCase ++ str->String.sliceToEnd(~start=1)

let toTitleCase = str => str->String.split(" ")->Array.map(capitalize)->Array.join(" ")
let searchContains = (q, text) => text->String.toLowerCase->String.includes(q->String.toLowerCase)

let makeTitleFromUrl = url => {
  let base =
    url
    ->String.replace("https://", "")
    ->String.replace("www.", "")

  Js.String.replaceByRe(
    %re("/\.(com|net|org|co|in|us|netlify.app)$/"),
    "",
    base
    ->String.split("/")
    ->Array.get(0)
    ->Option.getOr(base),
  )
  ->String.replaceAll(".", " ")
  ->toTitleCase
}

let readClipboard: unit => promise<string> = %raw(`function () {
return navigator.clipboard.readText()
 }`)

module JSON = {
  @scope("JSON") @val
  external parse: string => Js.Json.t = "parse"
}
