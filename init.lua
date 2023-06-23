-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'


    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use ('tjdevries/colorbuddy.nvim')
    use ('folke/lsp-colors.nvim')
    -- theme
    --use 'tomasiser/vim-code-dark'
    --use "EdenEast/nightfox.nvim" -- Packer
    use ('ellisonleao/gruvbox.nvim')

    use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use ('nvim-treesitter/nvim-treesitter-context')
    use ('nvim-treesitter/playground')

    -- autotag
    use ('windwp/nvim-ts-autotag')

    -- git blame
    use ('f-person/git-blame.nvim')

    -- trouble
    use({
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup {
                icons = false,
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    })

    use ('theprimeagen/harpoon')
    use ('mbbill/undotree')
    use ('tpope/vim-fugitive')
    use ('muniftanjim/prettier.nvim')
    use ('folke/neodev.nvim')
    use ('theprimeagen/vim-be-good')

    -- todo comments
    -- Lua
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
                -- signs = true, -- show icons in the signs column
                sign_priority = 8, -- sign priority
                -- keywords recognized as todo comments
                keywords = {
                    FIX = {
                        icon = " ", -- icon used for the sign, and in search results
                        color = "error", -- can be a hex color, or a named color (see below)
                        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                        -- signs = false, -- configure signs for some keywords individually
                    },
                    TODO = { icon = " ", color = "info" },
                    HACK = { icon = " ", color = "warning" },
                    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
                },
                gui_style = {
                    fg = "NONE", -- The gui style to use for the fg highlight group.
                    bg = "BOLD", -- The gui style to use for the bg highlight group.
                },
                merge_keywords = true, -- when true, custom keywords will be merged with the defaults
                -- highlighting of the line containing the todo comment
                -- * before: highlights before the keyword (typically comment characters)
                -- * keyword: highlights of the keyword
                -- * after: highlights after the keyword (todo text)
                highlight = {
                    multiline = true, -- enable multine todo comments
                    multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
                    multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
                    before = "", -- "fg" or "bg" or empty
                    keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
                    after = "fg", -- "fg" or "bg" or empty
                    pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
                    comments_only = true, -- uses treesitter to match keywords in comments only
                    max_line_len = 400, -- ignore lines longer than this
                    exclude = {}, -- list of file types to exclude highlighting
                },
                -- list of named colors where we try to extract the guifg from the
                -- list of highlight groups or use the hex color if hl not found as a fallback
                colors = {
                    error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
                    warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                    info = { "DiagnosticInfo", "#2563EB" },
                    hint = { "DiagnosticHint", "#10B981" },
                    default = { "Identifier", "#7C3AED" },
                    test = { "Identifier", "#FF00FF" }
                },
                search = {
                    command = "rg",
                    args = {
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                    },
                    -- regex that will be used to match keywords.
                    -- don't replace the (KEYWORDS) placeholder
                    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
                    -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
                },

            }
        end
    }

    -- theming below
    vim.opt.termguicolors = true
    use 'kyazdani42/nvim-web-devicons'
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    }
    use 'freddiehaddad/feline.nvim'

    local line_ok, feline = pcall(require, "feline")
    if not line_ok then
        return
    end

    local one_monokai = {
        fg = "#abb2bf",
        bg = "#1e2024",
        green = "#98c379",
        yellow = "#e5c07b",
        purple = "#c678dd",
        orange = "#d19a66",
        peanut = "#f6d5a4",
        red = "#e06c75",
        aqua = "#61afef",
        darkblue = "#282c34",
        dark_red = "#f75f5f",
    }

    local vi_mode_colors = {
        NORMAL = "green",
        OP = "green",
        INSERT = "yellow",
        VISUAL = "purple",
        LINES = "orange",
        BLOCK = "dark_red",
        REPLACE = "red",
        COMMAND = "aqua",
    }

    local c = {
        vim_mode = {
            provider = {
                name = "vi_mode",
                opts = {
                    show_mode_name = true,
                    -- padding = "center", -- Uncomment for extra padding.
                },
            },
            hl = function()
                return {
                    fg = require("feline.providers.vi_mode").get_mode_color(),
                    bg = "darkblue",
                    style = "bold",
                    name = "NeovimModeHLColor",
                }
            end,
            left_sep = "block",
            right_sep = "block",
        },
        gitBranch = {
            provider = "git_branch",
            hl = {
                fg = "peanut",
                bg = "darkblue",
                style = "bold",
            },
            left_sep = "block",
            right_sep = "block",
        },
        gitDiffAdded = {
            provider = "git_diff_added",
            hl = {
                fg = "green",
                bg = "darkblue",
            },
            left_sep = "block",
            right_sep = "block",
        },
        gitDiffRemoved = {
            provider = "git_diff_removed",
            hl = {
                fg = "red",
                bg = "darkblue",
            },
            left_sep = "block",
            right_sep = "block",
        },
        gitDiffChanged = {
            provider = "git_diff_changed",
            hl = {
                fg = "fg",
                bg = "darkblue",
            },
            left_sep = "block",
            right_sep = "right_filled",
        },
        separator = {
            provider = "",
        },
        fileinfo = {
            provider = {
                name = "file_info",
                opts = {
                    type = "relative-short",
                },
            },
            hl = {
                style = "bold",
            },
            left_sep = " ",
            right_sep = " ",
        },
        diagnostic_errors = {
            provider = "diagnostic_errors",
            hl = {
                fg = "red",
            },
        },
        diagnostic_warnings = {
            provider = "diagnostic_warnings",
            hl = {
                fg = "yellow",
            },
        },
        diagnostic_hints = {
            provider = "diagnostic_hints",
            hl = {
                fg = "aqua",
            },
        },
        diagnostic_info = {
            provider = "diagnostic_info",
        },
        lsp_client_names = {
            provider = "lsp_client_names",
            hl = {
                fg = "purple",
                bg = "darkblue",
                style = "bold",
            },
            left_sep = "left_filled",
            right_sep = "block",
        },
        file_type = {
            provider = {
                name = "file_type",
                opts = {
                    filetype_icon = true,
                    case = "titlecase",
                },
            },
            hl = {
                fg = "red",
                bg = "darkblue",
                style = "bold",
            },
            left_sep = "block",
            right_sep = "block",
        },
        file_encoding = {
            provider = "file_encoding",
            hl = {
                fg = "orange",
                bg = "darkblue",
                style = "italic",
            },
            left_sep = "block",
            right_sep = "block",
        },
        position = {
            provider = "position",
            hl = {
                fg = "green",
                bg = "darkblue",
                style = "bold",
            },
            left_sep = "block",
            right_sep = "block",
        },
        line_percentage = {
            provider = "line_percentage",
            hl = {
                fg = "aqua",
                bg = "darkblue",
                style = "bold",
            },
            left_sep = "block",
            right_sep = "block",
        },
        scroll_bar = {
            provider = "scroll_bar",
            hl = {
                fg = "yellow",
                style = "bold",
            },
        },
    }

    local left = {
        c.vim_mode,
        c.gitBranch,
        c.gitDiffAdded,
        c.gitDiffRemoved,
        c.gitDiffChanged,
        c.separator,
    }

    local middle = {
        c.fileinfo,
        c.diagnostic_errors,
        c.diagnostic_warnings,
        c.diagnostic_info,
        c.diagnostic_hints,
    }

    local right = {
        c.lsp_client_names,
        c.file_type,
        c.file_encoding,
        c.position,
        c.line_percentage,
        c.scroll_bar,
    }

    local components = {
        active = {
            left,
            middle,
            right,
        },
        inactive = {
            left,
            middle,
            right,
        },
    }

    feline.setup({
        components = components,
        theme = one_monokai,
    })
        vi_mode_colors = vi_mode_colors,


        --use {
    --    'nvim-lualine/lualine.nvim',
    --    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    --}

    -- ^^ hopefully theming

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {'williamboman/mason.nvim'},           -- Optional
            {'williamboman/mason-lspconfig.nvim'}, -- Optional
            {'glepnir/lspsaga.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},         -- Required
            {'hrsh7th/cmp-nvim-lsp'},     -- Required
            {'hrsh7th/cmp-buffer'},       -- Optional
            {'hrsh7th/cmp-path'},         -- Optional
            {'saadparwaiz1/cmp_luasnip'}, -- Optional
            {'hrsh7th/cmp-nvim-lua'},     -- Optional

            -- Snippets
            {'L3MON4D3/LuaSnip'},             -- Required
            {'rafamadriz/friendly-snippets'}, -- Optional
        }
    }

    --require('lualine').setup {
    --    options = {
    --        icons_enabled = true,
    --        theme = 'auto',
    --        component_separators = { },
    --        section_separators = { },
    --        disabled_filetypes = {
    --            statusline = {},
    --            winbar = {},
    --        },
    --        ignore_focus = {},
    --        always_divide_middle = true,
    --        globalstatus = false,
    --        refresh = {
    --            statusline = 1000,
    --            tabline = 1000,
    --            winbar = 1000,
    --        }
    --    },
    --    sections = {
    --        lualine_a = {'mode'},
    --        lualine_b = {'branch', 'diff', 'diagnostics'},
    --        lualine_c = {'filename'},
    --        lualine_x = {'encoding', 'fileformat', 'filetype'},
    --        lualine_y = {'progress'},
    --        lualine_z = {'location'}
    --    },
    --    inactive_sections = {
    --        lualine_a = {},
    --        lualine_b = {},
    --        lualine_c = {'filename'},
    --        lualine_x = {'location'},
    --        lualine_y = {},
    --        lualine_z = {}
    --    },
    --    tabline = {},
    --    winbar = {},
    --    inactive_winbar = {},
    --    extensions = {}
    --}

    require('nvim-ts-autotag').setup()

-- netrw
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- remap.lua
vim.g.mapleader = ' ' 

vim.keymap.set("n", "<leader>pv", ":Ex<CR>")
vim.keymap.set("n", "<leader>u", ":UndotreeShow<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Y", "yg$")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

--greatest remap ever
vim.keymap.set("x", "<leader>p", "\"_dP")

-- next greatest remap ever : asbjornHaland
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- this is going to get me cancelled
vim.keymap.set("i", "<C-c", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
-- unmap arrow keys for kinesis kb
vim.keymap.set("x", "<Up>", "<nop>")
vim.keymap.set("x", "<Down>", "<nop>")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux_sessionizer<CR>")
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- set.lua

--fat cursor !!!
--vim.opt.guicursor = ''

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- word wrap
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- highlight all search
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")








-- did this fix freezing ???
vim.opt.updatetime = 50













vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

-- lsp
local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    'html',
    'tsserver',
	'eslint',
	'rust_analyzer',
})

-- Fix Undefined global 'vim'
lsp.configure('lua-language-server', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({ select = true }),
	['<C-Space>'] = cmp.mapping.complete(),
})

lsp.set_preferences({
	sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.setup_nvim_cmp({
	mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
	local opts = {buffer = bufnr, remap = false}

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.lsp.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

-- colors.lua

--require('nightfox').setup({
--  options = {
--    -- Compiled file's destination location
--    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
--    compile_file_suffix = "_compiled", -- Compiled file suffix
--    transparent = true,     -- Disable setting background
--    terminal_colors = true,  -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
--    dim_inactive = false,    -- Non focused panes set to alternative background
--    module_default = true,   -- Default enable value for modules
--    colorblind = {
--      enable = false,        -- Enable colorblind support
--      simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
--      severity = {
--        protan = 0,          -- Severity [0,1] for protan (red)
--        deutan = 0,          -- Severity [0,1] for deutan (green)
--        tritan = 0,          -- Severity [0,1] for tritan (blue)
--      },
--    },
--    styles = {               -- Style to be applied to different syntax groups
--      comments = "NONE",     -- Value is any valid attr-list value `:help attr-list`
--      conditionals = "NONE",
--      constants = "NONE",
--      functions = "NONE",
--      keywords = "NONE",
--      numbers = "NONE",
--      operators = "NONE",
--      strings = "NONE",
--      types = "NONE",
--      variables = "NONE",
--    },
--    inverse = {             -- Inverse highlight for different types
--      match_paren = false,
--      visual = false,
--      search = false,
--    },
--    modules = {             -- List of various plugins and additional options
--      -- ...
--    },
--  },
--  palettes = {},
--  specs = {},
--  groups = {},
--})

-- setup must be called before loading
--vim.cmd("colorscheme codedark")

vim.o.background = "dark"
-- setup must be called before loading the colorscheme
-- Default options:
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = false,
    comments = false,
    operators = false,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "soft", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = true,
})
vim.cmd("colorscheme gruvbox")
--  :highlight SignColumn guibg=NONE
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
--vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { bg = "none", fg = "yellow" })
--vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = "none", fg = "red" })
-- :highlight SignColumn guibg=NONE

-- fugitive.lua
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

local JSpievak_Fugitive = vim.api.nvim_create_augroup("JSpievak_Fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
    group = JSpievak_Fugitive,
    pattern = "*",
    callback = function()
        if vim.bo.ft ~= "fugitive" then
            return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = {buffer = bufnr, remap = false}
        vim.keymap.set("n", "<leader>p", function()
            vim.cmd.Git('push')
        end, opts)

        -- rebase always
        vim.keymap.set("n", "<leader>P", function()
            vim.cmd.Git({'pull',  '--rebase'})
        end, opts)

        -- NOTE: It allows me to easily set the branch i am pushing and any tracking
        -- needed if i did not set the branch up correctly
        vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
    end,
})



-- harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })

end)

-- treesitter
require 'nvim-treesitter.install'.prefer_git = false

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "javascript", "lua", "c", "vim", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

end)

