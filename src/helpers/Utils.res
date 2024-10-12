module Utils = {
  @val @scope("window")
  external openUrl: (string, string) => unit = "open"

  let blur = %raw(`function blur(element)  { element.blur() }`)
  let focus = %raw(`function focus(element)  { element.focus() }`)

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
}
