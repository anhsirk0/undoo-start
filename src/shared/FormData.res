type t
@new external new: Dom.element => t = "FormData"

@send external get_: (t, string) => Nullable.t<string> = "get"

let get = (fd, key) => Nullable.toOption(fd->get_(key))
