@react.component
let make = (~onSubmit, ~title, ~url) => {
  <form onSubmit className="flex flex-col gap-2 xl:gap-4">
    <Input name="title" label="Title" required=true placeholder="DDG" defaultValue=title />
    <Input
      name="url"
      label="Url (use <Q> for query string)"
      required=true
      placeholder="https://duckduckgo.com/?q=<Q>"
      type_="url"
      defaultValue=url
    />
    <div className="flex flex-row gap-4 mt-4">
      <div className="grow" />
      <button className="btn resp-btn btn-primary">
        {React.string(title->String.length > 0 ? "Update" : "Add new Searcher")}
      </button>
    </div>
  </form>
}
