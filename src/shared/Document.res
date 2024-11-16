type t
@val external document: t = "document"
@set external setTitle: (t, string) => unit = "title"

@val @scope("document")
external addKeyListener: (string, ReactEvent.Keyboard.t => unit) => unit = "addEventListener"

@val @scope("document")
external removeKeyListener: (string, ReactEvent.Keyboard.t => unit) => unit = "removeEventListener"
