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
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<Tab>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = { enabled = false },
      })
    end,
  },
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

        -- Force full document sync to avoid incremental sync bug
        lsp_zero.set_server_config({
            flags = { allow_incremental_sync = false },
        })

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
              'matlab_ls',
            },
            handlers = {
              lsp_zero.default_setup,
              pyright = function()
                -- Auto-detect venv python path
                local python_path = nil
                local venv_dirs = { '.venv', 'venv', 'env' }
                for _, dir in ipairs(venv_dirs) do
                  local path = vim.fn.getcwd() .. '/' .. dir .. '/bin/python'
                  if vim.fn.executable(path) == 1 then
                    python_path = path
                    break
                  end
                end

                require('lspconfig').pyright.setup({
                  settings = {
                    python = {
                      pythonPath = python_path,
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
              matlab_ls = function()
                require('lspconfig').matlab_ls.setup({})
              end,
            }
        })

        -- Configure nvim-cmp to only show on Ctrl+Space
        local cmp = require('cmp')
        cmp.setup({
          completion = {
            autocomplete = false, -- Don't auto-popup
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(), -- Show with Ctrl+Space
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
          }),
          sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
          },
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
  {
    "martintrojer/jj-fugitive",
    dependencies = { "martintrojer/fugitive-core.nvim" },
  },
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
    {
      "mbbill/undotree",
      config = function()
        -- Set undotree window width
        vim.g.undotree_SplitWidth = 40
        -- Set undotree window position (right side)
        vim.g.undotree_WindowLayout = 2
        -- Show relative timestamps
        vim.g.undotree_RelativeTimestamp = 1
        -- Show shorter timestamps  
        vim.g.undotree_ShortIndicators = 1
        -- Focus undotree window when opened
        vim.g.undotree_SetFocusWhenToggle = 1
        
        -- Key mapping to toggle undotree
        vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
      end,
    },
    {
      "natecraddock/workspaces.nvim",
      dependencies = { "nvim-telescope/telescope.nvim" },
      config = function()
        require("workspaces").setup({
          hooks = {
            open = "Telescope find_files",
          },
        })
        
        -- Key mapping to open workspace selector
        vim.keymap.set('n', '<leader>pw', function()
          require('telescope').extensions.workspaces.workspaces()
        end, { desc = "Select workspace" })
      end,
    },
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      ft = { "markdown" },
      build = "cd app && yarn install",
    },
}

