open LinkStore

@react.component
let make = () => {
  let {links} = LinkStore.use()
  let linkItems = links->Array.map(link => <LinkItem link key={link.id->Int.toString} />)

  <React.Fragment>
    <div className="center px-4 xxl:py-4 ml-12 w-11/12 z-[5]">
      <div className="grid grid-cols-12 gap-4 lg:gap-6 w-full">
        <AddLinkForm />
        {linkItems->React.array}
      </div>
    </div>
  </React.Fragment>
}
