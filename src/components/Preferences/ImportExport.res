open Heroicons

module Helper = {
  let makeName = name => `${name}-${Date.make()->Date.toDateString->String.replaceAll(" ", "-")}`

  let makeOnExport = (data, onSome) => {
    () => {
      switch JSON.stringifyAny(data) {
      | Some(data) => onSome(data)
      | None => ()
      }
    }
  }

  let makeOnImport = (decoder, onOk) => {
    evt => {
      let files = ReactEvent.Form.target(evt)["files"]
      switch files[0] {
      | Some(file) => {
          let reader = FileReader.new()
          reader->FileReader.onload(data => {
            switch data->Utils.JSON.parse->decoder {
            | Ok(data) => onOk(data)
            | Error(s) => {
                Console.error(s)
                Console.error(data)
                Toast.error("Failed to import data, please verify if the data is of correct shape")
              }
            }
          })
          reader->FileReader.readAsText(file)
        }
      | None => ()
      }
    }
  }
}

module Item = {
  @react.component
  let make = (~title, ~info, ~onExport, ~onImport) => {
    <div className="col-span-1 flex flex-col gap-2 h-full border rounded-box p-4">
      <div className="flex gap-2">
        <div className="flex flex-col gap-2 grow">
          <p className="resp-title -mt-2"> {title->React.string} </p>
          <p className="title text-base-content/80"> {info->React.string} </p>
        </div>
        <button type_="button" className="btn btn-neutral btn-outline resp-btn" onClick=onExport>
          <Outline.DocumentDownloadIcon className="resp-icon" />
          {"Export"->React.string}
        </button>
      </div>
      <div className="grow" />
      <FormControl label="Import from file">
        <InputBase
          type_="file"
          className="file-input file-input-bordered file-input-sm xxl:file-input-md  grow"
          accept="application/json"
          onChange=onImport
        />
      </FormControl>
    </div>
  }
}

@react.component
let make = () => {
  let store = Store.Options.use()
  let bgStore = Store.Bg.use()
  let searcherStore = Store.Searcher.use()

  let exportOptions = Helper.makeOnExport(store.options, data => {
    data->Utils.downloadJson(Helper.makeName("Undoo-Startpage-Options"))
    Toast.success("Options data exported successfully")
  })
  let onImportOptions = Helper.makeOnImport(Decode.appOptions, data => {
    store.updateOptions(data)
    Toast.success("Options data imported successfully")
  })

  let exportPages = Helper.makeOnExport(store.pages, data => {
    data->Utils.downloadJson(Helper.makeName("Undoo-Startpage-Pages"))
    Toast.success("Pages data exported successfully")
  })
  let onImportPages = Helper.makeOnImport(Decode.appPages, data => {
    store.setPages(data)
    Toast.success("Pages data imported successfully")
  })

  let exportBgData = Helper.makeOnExport(bgStore.options, data => {
    data->Utils.downloadJson(Helper.makeName("Undoo-Startpage-Background"))
    Toast.success("Background data exported successfully")
  })
  let onImportBg = Helper.makeOnImport(Decode.appBgOptions, data => {
    bgStore.update(data)
    Toast.success("Background data imported successfully")
  })

  let exportSearcher = Helper.makeOnExport(searcherStore.engines, data => {
    data->Utils.downloadJson(Helper.makeName("Undoo-Startpage-Searcher"))
    Toast.success("Searcher data exported successfully")
  })
  let onImportSearcher = Helper.makeOnImport(Decode.appSearcher, data => {
    searcherStore.setEngines(data)
    Toast.success("Searcher data imported successfully")
  })

  <div className="grid grid-cols-2 grow gap-4 xxl:gap-8 xxl:pt-2">
    <Item
      title="Pages data"
      info="This data contains all your pages (sites) collection."
      onExport={_ => exportPages()}
      onImport=onImportPages
    />
    <Item
      title="Searcher data"
      info="This data contains all your searcher items collection."
      onExport={_ => exportSearcher()}
      onImport=onImportSearcher
    />
    <Item
      title="Preferences data"
      info="This data contains your general preferences."
      onExport={_ => exportOptions()}
      onImport=onImportOptions
    />
    <Item
      title="Background data"
      info="This data contains all your background customizations."
      onExport={_ => exportBgData()}
      onImport=onImportBg
    />
  </div>
}
