local dapui = require("dapui")
local dap = require("dap")

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

dapui.setup({
    expand_lines = true,
    controls = { enabled = true }, -- make false later?
    floating = { border = "rounded" },
    render = {
        max_type_length = 60,
        max_value_lines = 200,
    },
    layouts = {
        {
            elements = {
                { id = "scopes", size = 1.0 },
            },
            size = 15,
            position = "bottom",
        },
    },
})
