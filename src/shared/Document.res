type t
@val external document: t = "document"
@set external setTitle: (t, string) => unit = "title"

@val @scope("document")
external querySelectorAll_: string => Core__Iterator.t<Dom.element> = "querySelectorAll"

@val @scope("document")
external addKeyListener: (string, ReactEvent.Keyboard.t => unit) => unit = "addEventListener"

@val @scope("document")
external removeKeyListener: (string, ReactEvent.Keyboard.t => unit) => unit = "removeEventListener"

@val @scope("document")
external body: Dom.element = "body"

@val @scope("document")
external createElement: string => Dom.element = "createElement"

@send external appendChild: (Dom.element, Dom.element) => Dom.element = "appendChild"
@send external removeChild: (Dom.element, Dom.element) => unit = "removeChild"

let querySelectorAll = s => Array.fromIterator(querySelectorAll_(s))
