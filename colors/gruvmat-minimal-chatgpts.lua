-- File: lua/colors/gruvbox_material_minimal.lua
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end

vim.g.colors_name = "gruvbox_material_minimal"

-- Base colors (Gruvbox Material - soft contrast)
local bg          = "#32302f"
local fg          = "#d4be98"
local red         = "#ea6962"
local green       = "#a9b665"
local blue        = "#7daea3"
local yellow      = "#d8a657"
local gray        = "#504945"
local comment     = "#7c6f64"

local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Basic editor UI
hi("Normal", { fg = fg, bg = bg })
hi("NormalNC", { fg = fg, bg = bg })
hi("Visual", { bg = gray })
hi("CursorLine", { bg = "#3c3836" })
hi("CursorColumn", { bg = "#3c3836" })
hi("LineNr", { fg = gray, bg = bg })
hi("CursorLineNr", { fg = yellow, bold = true })
hi("VertSplit", { fg = gray, bg = bg })
hi("StatusLine", { fg = fg, bg = "#3a3735" })
hi("StatusLineNC", { fg = gray, bg = "#2b2b2b" })
hi("Pmenu", { fg = fg, bg = "#3c3836" })
hi("PmenuSel", { fg = bg, bg = yellow })

-- Syntax
hi("Comment", { fg = comment })
hi("Keyword", { fg = red })
hi("Identifier", { fg = fg })
hi("Function", { fg = red })
hi("Statement", { fg = fg })
hi("Type", { fg = fg })
hi("String", { fg = fg })
hi("Number", { fg = fg })
hi("Constant", { fg = fg })
hi("Operator", { fg = fg })
hi("PreProc", { fg = fg })
hi("Special", { fg = fg })
hi("Todo", { fg = red, bg = bg, bold = true })

-- Diagnostics (LSP)
hi("DiagnosticError", { fg = red })
hi("DiagnosticWarn", { fg = yellow })
hi("DiagnosticInfo", { fg = blue })
hi("DiagnosticHint", { fg = green })

-- Minimal Tree / File explorer
hi("Directory", { fg = blue })

-- Cursor
hi("Cursor", { reverse = true })

-- Match
hi("MatchParen", { bg = "#3a3735", bold = true })

-- Search
hi("Search", { bg = "#665c54", fg = bg })
hi("IncSearch", { bg = yellow, fg = bg })

-- Diff
hi("DiffAdd", { bg = "#394634" })
hi("DiffChange", { bg = "#45403d" })
hi("DiffDelete", { bg = "#5a3c3c" })

-- Minimal tabline
hi("TabLine", { fg = gray, bg = "#2b2b2b" })
hi("TabLineSel", { fg = fg, bg = "#3a3735", bold = true })
hi("TabLineFill", { bg = bg })

-- variables
-- Treesitter variables & punctuation (minimal look)
hi("@variable", { fg = yellow })          -- Normal variables
hi("@variable.parameter", { fg = fg })    -- Function parameters
hi("@variable.builtin", { fg = blue })    -- Built-ins like 'self', 'this'
hi("@punctuation.delimiter", { fg = fg }) -- Commas, colons, semicolons
hi("@punctuation.bracket", { fg = fg })   -- (), [], {}
hi("@punctuation.special", { fg = fg })   -- Special punctuation
