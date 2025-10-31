-- wrap on for md and txt files
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "markdown", "text" },
    callback = function()
        vim.opt_local.wrap = true
    end,
})

-- remove git commit message auto cut off
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "gitcommit" },
    callback = function()
        vim.opt_local.textwidth = 0
    end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    pattern = { "*.cs" },
    callback = function()
        vim.lsp.codelens.refresh({ bufnr = 0 })
    end,
})

-- vim.api.nvim_create_autocmd({ "FileType" }, {
--     pattern = { "fugitive" },
--     callback = function()
--         vim.cmd("only")
--     end,
-- })
