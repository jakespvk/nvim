-- colors/simple.lua

-- Define base colors
local bg         = "#32302f"
local fg         = "#d4be98"
local fg2        = "#ddc781"
local comment    = "#7c6f64"
local kw         = "#7daea3"
local accent     = "#ea6962"
local accent2    = "#d3869b"

-- Define highlight groups
local highlights = {
    Normal          = { fg = fg, bg = bg },
    NormalNC        = { fg = fg, bg = bg },
    NormalFloat     = { fg = fg, bg = bg },
    FloatBorder     = { fg = fg, bg = bg },

    Comment         = { fg = comment },
    Constant        = { fg = fg },
    String          = { fg = fg },
    Character       = { fg = fg },
    Number          = { fg = fg },
    Boolean         = { fg = fg },
    Float           = { fg = fg },

    Identifier      = { fg = fg }, -- accent
    Function        = { fg = fg },
    Statement       = { fg = fg },
    Conditional     = { fg = fg }, -- kw
    Repeat          = { fg = fg }, -- kw
    Label           = { fg = fg }, -- kw
    Operator        = { fg = fg },
    Keyword         = { fg = fg },

    PreProc         = { fg = fg },
    Include         = { fg = fg }, -- kw
    Define          = { fg = fg }, -- kw
    Macro           = { fg = fg },
    PreCondit       = { fg = fg },

    Type            = { fg = fg }, -- fg2
    StorageClass    = { fg = fg },
    Structure       = { fg = fg },
    Typedef         = { fg = fg },

    Special         = { fg = fg },
    SpecialChar     = { fg = fg },
    Tag             = { fg = fg },
    Delimiter       = { fg = fg },
    SpecialComment  = { fg = fg },
    Debug           = { fg = fg },

    Underlined      = { fg = fg, underline = true },
    Bold            = { fg = fg, bold = true },
    Italic          = { fg = fg, italic = true },

    Error           = { fg = accent },
    WarningMsg      = { fg = accent },
    DiagnosticError = { fg = accent },

    CursorLine      = { bg = "#3c3836" },
    Visual          = { bg = "#504945" },
    LineNr          = { fg = comment },
    CursorLineNr    = { fg = fg, bold = true },

    -- Others just set to fg
    Title           = { fg = fg },
    Question        = { fg = fg },
    MoreMsg         = { fg = fg },
    ModeMsg         = { fg = fg },
    Search          = { fg = fg },
    IncSearch       = { fg = fg },
    Directory       = { fg = fg },
    Pmenu           = { fg = fg, bg = "#3c3836" },
    PmenuSel        = { fg = bg, bg = fg },
}

-- Apply highlights
for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
end

vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "CursorColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "Whitespace", { fg = comment, bg = "none" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#3c3836" })
vim.api.nvim_set_hl(0, "@variable", { fg = accent })
vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = accent })
vim.api.nvim_set_hl(0, "@lsp.type.parameter", { fg = accent })
