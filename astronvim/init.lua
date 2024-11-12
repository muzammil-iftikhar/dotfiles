return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false, -- automatically quit the current session after a successful update
    remotes = { -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },
  -- Set colorscheme to use
  colorscheme = "dracula", -- catppuccin, astrodark, sonokai, dracula
  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },
  lsp = {
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
  },
  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },
  options = {
    opt = {
      -- set to true or false etc.
      relativenumber = true, -- sets vim.opt.relativenumber
      number = true, -- sets vim.opt.number
      spell = false, -- sets vim.opt.spell
      signcolumn = "yes", -- sets vim.opt.signcolumn to yes
      wrap = true, -- sets vim.opt.wrap
      timeout = true,
      timeoutlen = 300,
      termguicolors = true,
    },
    g = {
      mapleader = " ", -- sets vim.g.mapleader
      autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
      cmp_enabled = true, -- enable completion at start
      autopairs_enabled = true, -- enable autopairs at start
      diagnostics_mode = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
      icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
      ui_notifications_enabled = true, -- disable notifications when toggling UI elements
      codeium_disable_bindings = 1,
      loaded_netrw = 1,
      loaded_netrwPlugin = 1,
    },
  },

  mappings = {
    n = {
      ["<C-q>"] = false,
      ---@diagnostic disable-next-line: duplicate-index
      ["<C-s>"] = false,
      ---@diagnostic disable-next-line: duplicate-index
      ["<leader>w"] = false,
      ["]b"] = false,
      ["[b"] = false,
      ---@diagnostic disable-next-line: duplicate-index
      ["<C-s>"] = { ":w!<CR>", desc = "Save" },
      ["<Tab>"] = {
        function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
        desc = "Next buffer",
      },
      ["<S-Tab>"] = {
        function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
        desc = "Previous buffer",
      },
      -- better increment/decrement
      ["-"] = { "<c-x>", desc = "Descrement number" },
      ["+"] = { "<c-a>", desc = "Increment number" },
      -- Neotree
      ["<leader>e"] = { ":NvimTreeToggle<CR>", desc = "NvimTree Toggle" },
      -- Spectre
      ["<leader>s"] = { desc = "Spectre" },
      ["<leader>so"] = { "<cmd>lua require('spectre').open()<cr>", desc = "Open Spectre", silent = true },
      ["<leader>sw"] = {
        "<cmd>lua require('spectre').open_visual({select_word=true})<CR>",
        desc = "Search current word",
        silent = true,
      },
      ["<leader>sp"] = {
        "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>",
        desc = "Search in current file",
        silent = true,
      },
      -- Convert vertical buffers to diff mode
      ["<leader>bS"] = {
        function()
          local current_win = vim.api.nvim_get_current_win()
          local windows = vim.api.nvim_list_wins()

          for _, win in ipairs(windows) do
            vim.api.nvim_set_current_win(win)
            local diffthis = vim.api.nvim_win_get_option(win, "diff")
            if diffthis then
              vim.api.nvim_command "diffoff"
            else
              vim.api.nvim_command "diffthis"
            end
          end

          vim.api.nvim_set_current_win(current_win)
        end,

        desc = "Sync Diff Buffers",
      },
    },
    -- Terminal mappings
    t = {
      -- setting a mapping to false will disable it
      -- ["<esc>"] = false,
      ["<C-l>"] = false,
    },
    -- Visual mappings
    v = {},
    i = {
      ["<C-h>"] = { "<Left>" },
      ["<C-l>"] = { "<Right>" },
      ["<C-k>"] = { "<Up>" },
      ["<C-j>"] = { "<Down>" },
    },
  },
  -- set highlights for all themes
  -- use a function override to let us use lua to retrieve colors from highlight group
  -- there is no default table so we don't need to put a parameter for this function
  highlights = {
    -- This function will make telescope window look like nv chad
    init = function()
      local get_hlgroup = require("astronvim.utils").get_hlgroup
      -- get highlights from highlight groups
      local normal = get_hlgroup "Normal"
      local fg, bg = normal.fg, normal.bg
      local bg_alt = get_hlgroup("Visual").bg
      local green = get_hlgroup("String").fg
      local red = get_hlgroup("Error").fg
      -- return a table of highlights for telescope based on colors gotten from highlight groups
      return {
        TelescopeBorder = { fg = bg_alt, bg = bg },
        TelescopeNormal = { bg = bg },
        TelescopePreviewBorder = { fg = bg, bg = bg },
        TelescopePreviewNormal = { bg = bg },
        TelescopePreviewTitle = { fg = bg, bg = green },
        TelescopePromptBorder = { fg = bg_alt, bg = bg_alt },
        TelescopePromptNormal = { fg = fg, bg = bg_alt },
        TelescopePromptPrefix = { fg = red, bg = bg_alt },
        TelescopePromptTitle = { fg = bg, bg = red },
        TelescopeResultsBorder = { fg = bg, bg = bg },
        TelescopeResultsNormal = { bg = bg },
        TelescopeResultsTitle = { fg = bg, bg = bg },
      }
    end,
  },
  plugins = {
    {
      "catppuccin/nvim",
      as = "catppuccin",
      config = function()
        require("catppuccin").setup {
          styles = {
            comments = {},
          },
        }
      end,
    },
    {
      "sainnhe/sonokai",
      init = function() -- init function runs before the plugin is loaded
        vim.g.sonokai_style = "shusia"
      end,
    },
    {
      "tpope/vim-surround",
      version = "*",
      event = "VeryLazy",
    },
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      cmd = { "NvimTreeToggle" },
      config = function()
        require("nvim-tree").setup {
          sort_by = "case_sensitive",
          sync_root_with_cwd = true,
          respect_buf_cwd = true,
          update_focused_file = {
            enable = true,
            update_root = true,
          },
          view = {
            width = 35,
          },
          renderer = {
            group_empty = true,
          },
          filters = {
            dotfiles = true,
          },
        }
      end,
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      enabled = false,
      -- main = "ibl",
      --   opts = {},
    },
    {
      "Exafunction/codeium.vim",
      lazy = true,
      event = "InsertEnter",
      config = function()
        vim.keymap.set("i", "<c-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
        vim.keymap.set("i", "<M-9>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
        vim.keymap.set("i", "<M-0>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
        vim.keymap.set("i", "<c-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
      end,
    },
    {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup {
          layout = {
            height = { min = 4, max = 25 }, -- min and max height of the columns
            width = { min = 20, max = 50 }, -- min and max width of the columns
            spacing = 5, -- spacing between columns
            align = "left", -- align columns left, center or right
          },
        }
      end,
    },
    { "nvim-neo-tree/neo-tree.nvim", enabled = false },
    {
      "williamboman/mason-lspconfig.nvim",
      -- overrides `require("mason-lspconfig").setup(...)`
      opts = {
        ensure_installed = {
          "lua_ls",
          "ansiblels",
          "bashls",
          "terraformls",
          "jsonls",
          "docker_compose_language_service",
          "dockerls",
          "gopls",
          "html",
          "marksman",
          "pyright",
          "sqlls",
          "ruby_ls",
          "yamlls",
        },
      },
    },
    {
      "jay-babu/mason-null-ls.nvim",
      -- overrides `require("mason-null-ls").setup(...)`
      opts = {
        ensure_installed = {
          "prettier",
          "stylua",
          "gitsigns",
          "gomodifytags",
          "hadolint",
          "jsonlint",
          "autoflake",
          "black",
          "fixjson",
          "gofmt",
          "goimports",
          "hclfmt",
          "isort",
          "mdformat",
          "shfmt",
          "sqlfmt",
          "taplo",
          "terraform_fmt",
          "xmlformat",
          "yamlfmt",
        },
        automatic_setup = true,
      },
    },
    -- In case you want to override the default null-ls setup
    -- {
    --   "jose-elias-alvarez/null-ls.nvim",
    --   dependencies = { "nvim-lua/plenary.nvim" },
    --   config = function()
    --     require("null-ls").setup {
    --       sources = {
    --         require("null-ls").builtins.formatting.cbfmt,
    --         require("null-ls").builtins.formatting.mdformat,
    --         require("null-ls").builtins.formatting.prettier.with {
    --           filetypes = { "html", "json", "yaml", "markdown" },
    --         },
    --       },
    --     }
    --   end,
    -- },
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      opts = {
        size = 10,
        open_mapping = [[<M-1>]],
        hide_numbers = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      },
      keys = {
        "<M-1>",
      },
    },
    {
      "mbbill/undotree",
      cmd = "UndotreeToggle",
    },
    {
      "ThePrimeagen/harpoon",
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
        "<M-a>",
        "<M-e>",
        "<M-2>",
        "<M-3>",
      },
    },
    {
      "nvim-pack/nvim-spectre",
      dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
      keys = {
        "<leader>s",
      },
    },
    {
      "AstroNvim/astrocommunity",
      { import = "astrocommunity.motion.hop-nvim" },
      { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
      { import = "astrocommunity.colorscheme.dracula-nvim" },
    },
  },
  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- Ansible Configuration
    local function yaml_ft(path, bufnr)
      -- get content of buffer as string
      local content = vim.filetype.getlines(bufnr)
      if type(content) == "table" then content = table.concat(content, "\n") end

      -- check if file is in roles, tasks, or handlers folder
      local path_regex = vim.regex "(tasks\\|roles\\|handlers)/"
      if path_regex and path_regex:match_str(path) then return "yaml.ansible" end
      -- check for known ansible playbook text and if found, return yaml.ansible
      local regex = vim.regex "hosts:\\|tasks:"
      if regex and regex:match_str(content) then return "yaml.ansible" end

      -- return yaml if nothing else
      return "yaml"
    end

    vim.filetype.add {
      extension = {
        yml = yaml_ft,
        yaml = yaml_ft,
      },
    }
    -- Ansible Configuration End

    -- Hop Configuration
    local hop = require "hop"
    local directions = require("hop.hint").HintDirection
    vim.keymap.set(
      "",
      "f",
      function() hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = true } end,
      { remap = true }
    )
    vim.keymap.set(
      "",
      "F",
      function() hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = true } end,
      { remap = true }
    )
    vim.keymap.set(
      "",
      "t",
      function() hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 } end,
      { remap = true }
    )
    vim.keymap.set(
      "",
      "T",
      function() hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 } end,
      { remap = true }
    )
    -- Hop Configuration End

    -- Harpoon Configuration
    local mark = require "harpoon.mark"
    local ui = require "harpoon.ui"
    vim.keymap.set("n", "<M-a>", mark.add_file)
    vim.keymap.set("n", "<M-e>", ui.toggle_quick_menu)
    vim.keymap.set("n", "<M-2>", function() ui.nav_file(1) end)
    vim.keymap.set("n", "<M-3>", function() ui.nav_file(2) end)
    -- Harpoon Configuration End

    -- Undotree Configuration
    vim.keymap.set("n", "<F1>", ":UndotreeToggle<CR>", { noremap = true, silent = true })
    -- Layout
    if not vim.g.undotree_WindowLayout then vim.g.undotree_WindowLayout = 2 end
    -- Width
    if not vim.g.undotree_SplitWidth then
      if vim.g.undotree_ShortIndicators == 1 then
        vim.g.undotree_SplitWidth = 30
      else
        vim.g.undotree_SplitWidth = 36
      end
    end
    -- Focus window
    if not vim.g.undotree_SetFocusWhenToggle then vim.g.undotree_SetFocusWhenToggle = 1 end
    -- Undotree Configuration End

    -- Spectre Configuration
    local api = vim.api
    -- windows to close with "q"
    api.nvim_create_autocmd("FileType", {
      pattern = { "help", "startuptime", "qf", "lspinfo", "spectre_panel" },
      command = [[nnoremap <buffer><silent> q :close<CR>]],
    })
    api.nvim_create_autocmd("FileType", { pattern = "man", command = [[nnoremap <buffer><silent> q :quit<CR>]] })
    -- Spectre Configuration End
  end,
}
