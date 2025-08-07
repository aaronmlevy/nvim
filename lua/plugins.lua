-- lua/plugins.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("config.telescope")
    end,
  },
  { "nvim-tree/nvim-web-devicons" },
  { "ryanoasis/vim-devicons" },
  --{
    --"eddyekofo94/gruvbox-flat.nvim",
    --config = function()
      --vim.g.gruvbox_flat_style = "dark"
      --vim.cmd("colorscheme gruvbox-flat")
    --end,
  --},
  {
    "Mofiqul/vscode.nvim",
    config = function()
        local vscode = require("vscode")
        vscode.setup({
            style = "dark", -- Choose 'dark' or 'light'
            transparent = false, -- Enable transparent background
            italic_comments = true, -- Enable italic comments
            disable_nvimtree_bg = true, -- Disable background color for NvimTree
        })
        vscode.load()

        -- Remove background color for comments
        vim.api.nvim_set_hl(0, "Comment", { bg = "NONE" })
    end
    },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",  -- same as `run = ":TSUpdate"` in packer
    config = function()
        require("config.treesitter")
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("config.copilot_chat")
    end,
  },
  { "github/copilot.vim" },
  { "rcarriga/nvim-notify" },
  { "stevearc/dressing.nvim" },
  { "preservim/nerdcommenter" },
  { "jpalardy/vim-slime",
  config = function()
      require("config.vim_slime")
  end,
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
        local lsp_zero = require('lsp-zero')
        
        lsp_zero.on_attach(function(client, bufnr)
            local opts = {buffer = bufnr}
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        end)

        -- Disable virtual text globally
        vim.diagnostic.config({
            virtual_text = false,
            signs = false
        })
        
        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = {
              'pyright',
              'clangd',
            },
            handlers = {
              lsp_zero.default_setup,
              pyright = function()
                require('lspconfig').pyright.setup({
                  settings = {
                    python = {
                      analysis = {
                        diagnosticMode = "openFilesOnly",
                        typeCheckingMode = "off",
                        diagnosticSeverityOverrides = {
                          reportGeneralTypeIssues = "none",
                          reportOptionalMemberAccess = "none",
                          reportOptionalSubscript = "none",
                          reportPrivateImportUsage = "none",
                        }
                      }
                    }
                  },
                })
              end,
            }
        })
    end,
  },
  { "preservim/nerdtree",
  config = function()
      require("config.nerdtree")
  end},
  { "romainl/vim-cool" },
  { "vim-airline/vim-airline" },
  { "vim-airline/vim-airline-themes" },
  { "qpkorr/vim-bufkill" },
  { "easymotion/vim-easymotion" },
  { "airblade/vim-gitgutter" },
  { "tpope/vim-fugitive" },
  { "mg979/vim-visual-multi",
    enabled = not vim.g.vscode,  -- Only load outside VSCode
    init=function()
      vim.g.VM_maps = {
        ['Find Under'] = '<C-f>',
        ['Find Subword Under'] = '<C-f>',
        ['Add Cursor Down'] = '<C-z>'
      }
    end
  },
  { "liuchengxu/vista.vim", 
  config=function()
      require("config.vista")
  end
  },
  { "stsewd/isort.nvim", build = ":UpdateRemotePlugins" },
  {
    "ellisonleao/glow.nvim",
    config = function()
      require("glow").setup()
    end,
  },
  { "will133/vim-dirdiff" },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        config = function()
            require("config.flash").setup()
        end
    },
    {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        local harpoon = require("harpoon")
        harpoon:setup({
            settings = {
                save_on_toggle = false,
                sync_on_ui_close = false,
            }
        })
        
        -- Load keybindings
        require("config.harpoon_keybindings")
    end,
    },
}

