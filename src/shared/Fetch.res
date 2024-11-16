module Response = {
  type t<'data>
  @send external text: t<'data> => promise<'data> = "text"
}

@val @scope("globalThis")
external fetch: (string, 'params) => promise<Response.t<string>> = "fetch"

let getTitle = async url => {
  try {
    let params = {
      "mode": "no-cors",
      "headers": {"Access-Control-Allow-Origin": "*"},
    }
    let response = await fetch(url, params)
    let data = await response->Response.text
    let regexp = RegExp.fromString("<title>(.*?)<\/title>")

    switch regexp->RegExp.exec(data) {
    | None => url
    | Some(result) => result[1]->Option.getOr(Some(url))->Option.getOr(url)
    }
  } catch {
  | _ => url
  }
}
