type t
@new external new: unit => t = "FileReader"
@send external readAsDataURL: (t, Js.File.t) => unit = "readAsDataURL"

let onload: (t, string => unit) => unit = %raw(`function (reader, cb) {
      reader.onload = function (e) { cb(e.target.result) }
}`)
