type containerProps = {pauseOnFocusLoss?: bool, position?: string}

@module("react-toastify") external container: React.component<containerProps> = "ToastContainer"

@module("react-toastify") @scope("toast")
external success: string => unit = "success"

// @module("react-toastify") @scope("toast")
// external warn: string => unit = "warn"

@module("react-toastify") @scope("toast")
external error: string => unit = "error"
