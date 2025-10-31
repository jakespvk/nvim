local dap = require("dap")

local netcoredbg_adapter = {
    type = "executable",
    command = "netcoredbg",
    args = { "--interpreter=vscode" },
}

dap.adapters.netcoredbg = netcoredbg_adapter
dap.adapters.coreclr = netcoredbg_adapter

local dll_path

local fzf = require("fzf-lua")

local function fzf_input_path()
    local runner = coroutine.wrap(function()
        local co = coroutine.running()
        fzf.files({
            prompt = "Select file> ",
            actions = {
                ["default"] = function(selected)
                    dll_path = vim.fn.fnamemodify(selected[1], ":p")
                    coroutine.resume(co, dll_path)
                end,
                ["esc"] = function() coroutine.resume(co, nil) end,
            },
        })
        return coroutine.yield()
    end)

    -- 🔑 run the wrapped coroutine
    return runner()
end

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = dll_path,
    },
}

local map = vim.keymap.set

local opts = { noremap = true, silent = true }

map("n", "<F5>", function()
    fzf_input_path()
    require('dap').continue()
end, opts)
map("n", "<F6>", "<cmd>lua require('neotest').run.run({ strategy = 'dap' })<CR>", opts)
map("n", "<leader>bp", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
map("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", opts)
map("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", opts)
map("n", "<F8>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
-- map("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
map("n", "<leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", opts)
map("n", "<leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", opts)
map("n", "<leader>dt", "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>",
    { noremap = true, silent = true, desc = 'debug nearest test' })

vim.fn.sign_define('DapBreakpoint',
    {
        text = '⚪',
        texthl = 'DapBreakpointSymbol',
        linehl = 'DapBreakpoint',
        numhl = 'DapBreakpoint'
    })

vim.fn.sign_define('DapStopped',
    {
        text = '🔴',
        texthl = 'DapBreakpointSymbol',
        linehl = 'DapBreakpoint',
        numhl = 'DapBreakpoint'
    })

vim.fn.sign_define('DapBreakpointRejected',
    {
        text = '⭕',
        texthl = 'DapBreakpointSymbol',
        linehl = 'DapBreakpoint',
        numhl = 'DapBreakpoint'
    })
