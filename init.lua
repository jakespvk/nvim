-- IF THINGS ARE NOT WORKING, ADD OPTION LAZY = FALSE
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require("lazy").setup({

    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate'
    },

    {
        "mason-org/mason.nvim",
        opts = {}
    },

    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        -- Optional dependencies
        -- dependencies = { { "nvim-mini/mini.icons", opts = {} } },
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
    },

    { 'rcarriga/nvim-notify' },

    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- or if using mini.icons/mini.nvim
        -- dependencies = { "nvim-mini/mini.icons" },
        opts = {}
    },

    {
        -- Debug Framework
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
        },
        config = function()
            require "configs.nvim-dap"
        end,
        event = "VeryLazy",
    },
    { "nvim-neotest/nvim-nio" },
    {
        -- UI for debugging
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            require "configs.nvim-dap-ui"
        end,
    },
    {
        "nvim-neotest/neotest",
        requires = {
            {
                "Issafalcon/neotest-dotnet",
            }
        },
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter"
        }
    },
    {
        "Issafalcon/neotest-dotnet",
        lazy = false,
        dependencies = {
            "nvim-neotest/neotest"
        }
    },

    {
        "seblyng/roslyn.nvim",
        ft = "cs",
        ---@module 'roslyn.config'
        ---@type RoslynNvimConfig
        opts = {
            -- your configuration comes here; leave empty for default settings
            filewatching = "roslyn", -- "auto"
            choose_target = function(target)
                return vim.iter(target):find(function(item)
                    if string.match(item, "OneInc.PolicyOne.All.sln") then
                        return item
                    end
                end)
            end,
        },
    },

    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
            -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        }
    },

    { 'davidosomething/vim-colors-meh' },
    -- theme
    {
        'sainnhe/gruvbox-material',
        lazy = true,

        config = function()
            vim.g.gruvbox_material_better_performance = 1
            ---- Fonts
            vim.g.gruvbox_material_disable_italic_comment = 1
            vim.g.gruvbox_material_enable_italic = 0
            vim.g.gruvbox_material_enable_bold = 1
            vim.g.gruvbox_material_transparent_background = 1
            ---- Themes
            -- vim.g.gruvbox_material_foreground = 'mix'
            -- vim.g.gruvbox_material_background = 'soft'
            -- vim.g.gruvbox_material_background = 'hard'
            -- vim.g.gruvbox_material_ui_contrast = 'high' -- The contrast of line numbers, indent lines, etc.
            -- vim.g.gruvbox_material_float_style = 'dim' -- Background of floating windows
            vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
        end
    },

    { 'hardselius/warlock' },

    -- {
    --     'razak17/tailwind-fold.nvim',
    --     lazy = true,
    --     opts = {
    --         enabled = true,
    --         symbol = "├ù",
    --         highlight = {
    --             fg = "#38BDF8",
    --         },
    --         ft = { 'html', 'svelte', 'astro', 'vue', 'typescriptreact', 'javascriptreact' },
    --     },
    --     dependencies = { 'nvim-treesitter/nvim-treesitter' },
    -- },

    -- autotag
    ('windwp/nvim-ts-autotag'),

    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true,
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
        opts = {}
    },

    {
        'saghen/blink.cmp',
        dependencies = 'rafamadriz/friendly-snippets',

        version = 'v0.*',

        opts = {
            keymap = { preset = 'default' },

            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono'
            },

            signature = { enabled = true },

            enabled = function()
                local disabled = false
                disabled = disabled or vim.bo.filetype == "markdown"
                disabled = disabled or vim.bo.filetype == "git"
                disabled = disabled or vim.bo.filetype == "COMMIT_EDITMSG"
                disabled = disabled or vim.bo.buftype == "nofile"
                disabled = disabled or vim.bo.buftype == "prompt"
                return not disabled
            end
        },
    },

    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            'saghen/blink.cmp',
            ---@diagnostic disable-next-line: missing-fields
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
        },
        config = function()
            -- local capabilities = require('blink.cmp').get_lsp_capabilities()

            -- vim.lsp.config("angularls", {
            --     capabilities = capabilities,
            -- })
            -- vim.lsp.enable("angularls")

            -- require("lspconfig").tailwindcss.setup { capabilities = capabilities }
            -- require("lspconfig").ruff.setup { capabilities = capabilities }
            -- require("lspconfig").pylsp.setup { capabilities = capabilities }
            -- require("lspconfig").emmet_language_server.setup { capabilities = capabilities }
            -- require("lspconfig").zls.setup { capabilities = capabilities }
            -- require("lspconfig").clangd.setup {
            --     capabilities = capabilities,
            --     cmd = {
            --         "clangd",
            --         "--fallback-style=webkit"
            --     }
            -- }
            -- require("lspconfig").gopls.setup {
            --     capabilities = capabilities,
            --     settings = {
            --         gopls = {
            --             analyses = {
            --                 unusedparams = true,
            --             },
            --             staticcheck = true,
            --         },
            --     },
            -- }

            --- COMMENTED OUT LSP CONFIG
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end


                    vim.o.statusline = "%<%f %h%w%m%r%=%#LspClientNameHl#%-4.( " ..
                        client.name .. " %)%* %-4.(%l:%c%V%) %P"

                    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol)
                    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float)
                    vim.keymap.set("n", "<leader>pd", "<cmd>Telescope diagnostics<cr>")
                    vim.keymap.set("n", "[d", vim.diagnostic.get_next)
                    vim.keymap.set("n", "]d", vim.diagnostic.get_prev)
                    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action)
                    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition)
                    vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
                    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help)

                    if client:supports_method('textDocument/formatting') then
                        -- local root_dir = client.config.root_dir
                        -- local prettier_configs = {
                        --     ".prettierrc", ".prettierrc.json", ".prettierrc.js",
                        --     "prettier.config.js", "prettier.config.cjs"
                        -- }
                        --
                        -- local function has_prettier_config()
                        --     if not root_dir then return false end
                        --     for _, file in ipairs(prettier_configs) do
                        --         if vim.fn.filereadable(root_dir .. "/" .. file) == 1 then
                        --             return true
                        --         end
                        --     end
                        --     return false
                        -- end
                        --
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = args.buf,
                            callback = function()
                                -- local filepath = vim.api.nvim_buf_get_name(args.buf)
                                -- if has_prettier_config() then
                                --     -- Save buffer so Prettier works on file, then reload after formatting
                                --     vim.api.nvim_buf_call(args.buf, function()
                                --         vim.cmd("write")
                                --     end)
                                --     vim.fn.jobstart(
                                --         { "pnpm", "prettier:write", filepath }, {
                                --             on_exit = function()
                                --                 vim.api.nvim_buf_call(
                                --                     args.buf,
                                --                     function()
                                --                         vim.cmd(
                                --                             "edit")
                                --                     end)
                                --             end,
                                --         })
                                -- else
                                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                                -- end
                            end,
                        })
                    end
                    -- if client:supports_method('textDocument/formatting') then
                    --     -- Format the current buffer on save
                    --     vim.api.nvim_create_autocmd('BufWritePre', {
                    --         buffer = args.buf,
                    --         callback = function()
                    --             vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                    --         end,
                    --     })
                    -- end
                end,
            })
        end,
    },

    -- supermaven
    "supermaven-inc/supermaven-nvim",

    -- git blame
    ('f-person/git-blame.nvim'),

    -- trouble
    ({
        "folke/trouble.nvim",
        lazy = false,
        config = function()
            require("trouble").setup {
                {
                    modes = {
                        preview_float = {
                            mode = "diagnostics",
                            preview = {
                                type = "float",
                                relative = "editor",
                                border = "rounded",
                                title = "Preview",
                                title_pos = "center",
                                position = { 0, -2 },
                                size = { width = 0.3, height = 0.3 },
                                zindex = 200,
                            },
                        },
                    },
                }
                -- icons = false,
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }),

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { { "nvim-lua/plenary.nvim" } }
    },
    ('mbbill/undotree'),
    ('tpope/vim-fugitive'),
    ('folke/neodev.nvim'),
    ('theprimeagen/vim-be-good'),

    -- theming below
    'kyazdani42/nvim-web-devicons',
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons' }
    },

    {
        'j-hui/fidget.nvim',
        opts = {
            display = {
                done_ttl = 5,
            },
            notification = {
                -- override_vim_notify = true,
                view = {
                    -- stack_upwards = false,
                    reflow = true,
                },
                window = {
                    winblend = 0,
                    border = "rounded",
                    -- align = "top",
                    max_width = 40,
                    tabstop = 4,
                },
            }
        }
    },

}, { defaults = { lazy = false } }) -- lazy = true, to auto lazy load

-- require('lualine').setup {
--     options = {
--         icons_enabled = true,
--         theme = 'auto',
--         --component_separators = {},
--         component_separators = '',
--         section_separators = { left = '', right = '' },
--         --section_separators = { left = '', right = '' },
--         disabled_filetypes = {
--             statusline = {},
--             winbar = {},
--         },
--         ignore_focus = {},
--         always_divide_middle = true,
--         globalstatus = false,
--         refresh = {
--             statusline = 1000,
--             tabline = 1000,
--             winbar = 1000,
--         }
--     },
--     sections = {
--         lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
--         lualine_b = { 'branch', 'diff', 'diagnostics' },
--         lualine_c = { { 'filename', path = 3 } },
--         lualine_x = { 'encoding', 'fileformat', 'filetype' },
--         lualine_y = { 'progress' },
--         lualine_z = {
--             { 'location', separator = { right = '' }, left_padding = 2 },
--         },
--     },
--     inactive_sections = {
--         lualine_a = {},
--         lualine_b = {},
--         lualine_c = { 'filename' },
--         lualine_x = { 'location' },
--         lualine_y = {},
--         lualine_z = {}
--     },
--     tabline = {},
--     winbar = {},
--     inactive_winbar = {},
--     extensions = {}
-- }

-- netrw
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
--
-- vim options (remove auto comment)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove({ 'r', 'o' })
    end,
})

-- remap.lua

vim.keymap.set("n", "<leader>z", "<cmd>only<CR>")

-- vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>")
-- vim.keymap.set("n", "-", "<cmd>Ex<CR>")
vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>")
vim.keymap.set("n", "-", "<cmd>Oil<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Y", "yg$")
vim.keymap.set("n", "J", "mzJ`z")
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

--greatest remap ever
vim.keymap.set("x", "<leader>p", "\"_dP")

-- next greatest remap ever : asbjornHaland
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- this is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

-- unmap arrow keys for kinesis kb
-- vim.keymap.set("i", "<Up>", "<nop>")
-- vim.keymap.set("i", "<Down>", "<nop>")

-- vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux_sessionizer<CR>")
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = false })
end)

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", ":s/\\<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set({ "v", "x" }, "<leader>s", "* :s//")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>t", "<cmd>tabnew<CR><cmd>term<CR>a")
vim.keymap.set("t", "<leader>t", "<C-\\><C-n>gt")
vim.keymap.set("n", "<leader>vs", "<cmd>vsplit<CR>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")


--- MINE

-- git blame
require('gitblame').setup({
    enabled = false,
})

vim.keymap.set("n", "<leader>gb", "<cmd>GitBlameToggle<CR>")

-- vim.g.gitblame_schedule_event = "CursorHold"
-- vim.g.gitblame_clear_event = "CursorHoldI"
vim.g.gitblame_delay = 0
-- vim.g.gitblame_virtual_text_column = 80


-- set.lua

--fat cursor !!!
--vim.opt.guicursor = ''

vim.opt.nu = true
-- vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- word wrap
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- os.getenv("HOME") ..
vim.opt.undofile = true

-- highlight all search
--vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 20
vim.opt.signcolumn = "yes"
-- vim.opt.winborder = "rounded"
vim.opt.isfname:append("@-@")

-- use fidget for notifications
-- vim.notify = require("fidget.notification").notify
require("notify").setup({
    merge_duplicates = false,
    max_width = 40,
    minimum_width = 40,
    render = "wrapped-compact",
    stages = "no_animation",
})
vim.notify = require("notify")
-- vim.keymap.set("n", "<cmd>messages<CR>", "<cmd>Telescope notify<CR>")

-- SOME COPYPASTAS FROM KICKSTART I FOUND INTRIGUING

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '> ', trail = '-', nbsp = '+', } --lead = '‧' }

-- Show which line your cursor is on
-- vim.opt.cursorline = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Enable break indent
vim.opt.breakindent = true

-- did this fix freezing ???
-- vim.opt.updatetime = 50

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- vim.opt.colorcolumn = "80"

--- lsp
-- vim.lsp.config["omnisharp"] = {
--     cmd = { "dotnet", "C:/Program Files/Omnisharp/OmniSharp.dll" },
-- }
-- vim.lsp.enable({
--     "omnisharp",
-- })

vim.diagnostic.config({
    virtual_text = { enable = true, bg = "none", fg = "red" }
})

-- colors.lua
vim.o.background = "dark"


-- ---@diagnostic disable-next-line: missing-fields
-- require("rose-pine").setup({
--     variant = 'moon',
--     extend_background_behind_borders = true,
--     styles = {
--         bold = true,
--         italic = false,
--         transparency = true,
--     },
-- })

-- ---@diagnostic disable-next-line: missing-fields
-- require("tokyonight").setup({
--     style = "storm", -- The theme comes in three styles, `storm`, `moon`, and `night`.
--     transparent = false,
--     styles = {
--         keywords = { italic = false },
--         comments = { italic = false },
--     },
-- })

-- vim.cmd("colorscheme gruvmat-simple")
-- vim.cmd("colorscheme meh")
vim.cmd("colorscheme gruvbox-material")

--  :highlight SignColumn guibg=NONE
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
-- vim.api.nvim_set_hl(0, "LineNr", { bg = "none", fg = "#757575" })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none", fg = "#db4740", bold = true })
-- vim.api.nvim_set_hl(0, "CursorColumn", { bg = "none" })
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
-- vim.api.nvim_set_hl(0, "Whitespace", { bg = "none" })
--vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { bg = "none", fg = "yellow" })
--vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = "none", fg = "#bf2a2a" })
--vim.api.nvim_set_hl(0, "VirtualText", { bg = "none", fg = "red" })
vim.api.nvim_set_hl(0, "LspClientNameHl", { bg = "#555555", bold = true })
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

        -- -- make fugitive the only open buffer
        -- vim.cmd("only")
        local bufnr = vim.api.nvim_get_current_buf()
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "<leader>p", function()
            vim.cmd.Git('push')
        end, opts)

        -- rebase always
        vim.keymap.set("n", "<leader>P", function()
            vim.cmd.Git({ 'pull --rebase' })
        end, opts)

        -- NOTE: It allows me to easily set the branch i am pushing and any tracking
        -- needed if i did not set the branch up correctly
        vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
        vim.keymap.set("n", "<leader>o", ":Git remote ", opts);
    end,
})



-- harpoon
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

require('telescope').setup {
    defaults = {
        file_ignore_patterns = {
            "node_modules",
            "bin/Debug",
            "bin/Release",
            "obj/Debug",
            "obj/Release",
        },
        layout_strategy = "vertical",
        layout_config = {
            width = 0.9,
        }
    },
    extension = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    }
}
-- require('telescope').load_extension('fzf')
-- basic telescope configuration

-- telescope
require('fzf-lua').setup({
    "telescope",
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    winopts = {
        fullscreen = true,
    },
})
local builtin = require('telescope.builtin')
local fzf = require("fzf-lua")
vim.keymap.set('n', '<leader>pf', fzf.files)
vim.keymap.set('n', '<C-p>', fzf.git_files)
vim.keymap.set('n', '<leader>ps', fzf.live_grep)
-- function()
-- builtin.grep_string({ search = vim.fn.input("Grep > ") })
-- end
vim.keymap.set('n', '<leader>srr', builtin.lsp_references)
vim.keymap.set('n', '<leader>jl', builtin.jumplist)

-- treesitter
require 'nvim-treesitter'.setup {
    -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
    install_dir = vim.fn.stdpath('data') .. '/site'
}
require('nvim-treesitter').install({ 'rust', 'javascript', 'zig', 'typescript', 'lua', 'c', 'vim', 'query', 'html',
    'python', 'go', 'c_sharp', 'tsx' })
-- require 'nvim-treesitter.install'.prefer_git = false
-- require 'nvim-treesitter.install'.compilers = { "zig" }

---@diagnostic disable-next-line: missing-fields
-- require 'nvim-treesitter'.install { "typescript", "lua", "c", "vim", "query", "html", "python", "go", "zig", "c_sharp" }

-- undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- tailwind fold
vim.opt.conceallevel = 0 -- 2 for tailwind fold

-- supermaven
require("supermaven-nvim").setup({
    keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
    },
    ignore_filetypes = { "cpp", "c", "go", "zig", "markdown", "git", "COMMIT_EDITMSG", "cs", "text" },
    color = {
        suggestion_color = "#ffffff",
        cterm = 244,
    },
    log_level = "info",                -- set to "off" to disable logging completely
    disable_inline_completion = false, -- disables inline completion for use with cmp
    disable_keymaps = false,           -- disables built in keymaps for more manual control
    condition = function()
        return false
    end -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
})


---
--- USE THIS ONE
---
-- vim.g.clipboard = {
--     name = "WslClipboard",
--     copy = {
--         ["+"] = "clip.exe",
--         ["*"] = "clip.exe",
--     },
--     paste = {
--         ["+"] =
--         '', -- "powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace('`r', ''))",
--         ["*"] =
--         '', --"powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace('`r', ''))",
--     },
--     cache_enabled = 0,
-- }

-- vim.g.clipboard = {
--     name = 'win32yank-wsl',
--     copy = {
--         ['+'] = 'win32yank.exe -i --crlf',
--         ['*'] = 'win32yank.exe -i --crlf',
--     },
--     paste = {
--         ['+'] = 'win32yank.exe -o --lf',
--         ['*'] = 'win32yank.exe -o --lf',
--     },
--     cache_enabled = 0,
-- }

-- vim.filetype.add({
--     extension = { razor = 'razor' },
-- })


--- LSP setup

vim.lsp.config("roslyn", {
    -- cmd = {
    --     "dotnet",
    --     "C:/Apps/Roslyn/Microsoft.CodeAnalysis.LanguageServer.dll",
    --     "--logLevel",
    --     "Information",
    --     "--extensionLogDirectory",
    --     fs.joinpath(uv.os_tmpdir(), "roslyn_ls/logs"),
    --     "--stdio",
    -- },
    settings = {
        ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openFiles", -- "openFiles", -- "fullSolution"
            dotnet_compiler_diagnostics_scope = "openFiles",
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = true,
        },
        ["csharp|completion"] = {
            dotnet_provide_regex_completions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
        },
        ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = true,
        },
        ["csharp|formatting"] = {
            dotnet_organize_imports_on_format = false,
        },
    },
})
vim.lsp.config("ts_ls", {})
vim.lsp.config("lua_ls", {})
vim.lsp.config("angularls", {})
vim.lsp.config("cucumber-language-server", {})

vim.lsp.enable({ "lua_ls", "ts_ls", "angularls", "cucumber_language_server" })

-- vim.o.statusline = "%F %h%w%m%r%= %l:%c "
vim.o.statusline = "%<%f %h%w%m%r%=%-4.(%l:%c%V%) %P"

require("mason").setup({
    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
    },
})

require('nvim-ts-autotag').setup({
    opts = {
        -- Defaults
        enable_close = true,          -- Auto close tags
        enable_rename = true,         -- Auto rename pairs of tags
        enable_close_on_slash = false -- Auto close on trailing </
    },
    -- Also override individual filetype configs, these take priority.
    -- Empty by default, useful if one of the "opts" global settings
    -- doesn't work well in a specific filetype
    per_filetype = {
        ["html"] = {
            enable_close = true
        }
    }
})

require("oil").setup({
    view_options = {
        show_hidden = true,
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "oil*",
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end,
})

vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>w")

require("autocommands")
require("neotest").setup({
    adapters = {
        require("neotest-dotnet")
    }
})
