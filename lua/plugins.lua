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
  { "ryanoasis/vim-devicons",
    config = function()
      require("nvim-web-devicons").setup {}
    end,
  },
  {
    "eddyekofo94/gruvbox-flat.nvim",
    config = function()
      vim.g.gruvbox_flat_style = "dark"
      vim.cmd("colorscheme gruvbox-flat")
    end,
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
  end
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function() 
        require("config.lsp")
        require("config.lspconfig")
    end
  },
  { "preservim/nerdtree",
  config = function()
      require("config.nerdtree")
  end},
  { "williamboman/mason.nvim",
  config = function()
      require("config.mason")
  end

  },
  { "williamboman/mason-lspconfig.nvim" },
  { "romainl/vim-cool" },
  { "vim-airline/vim-airline" },
  { "vim-airline/vim-airline-themes" },
  { "qpkorr/vim-bufkill" },
  { "easymotion/vim-easymotion" },
  { "airblade/vim-gitgutter" },
  { "tpope/vim-fugitive" },
  { "mg979/vim-visual-multi",
  init=function()
    vim.g.VM_maps = {
      ['Find Under'] = '<C-f>',
      ['Find Subword Under'] = '<C-f>',
      ['Add Cursor Down'] = '<C-z>'
    }
  end},
  { "liuchengxu/vista.vim" },
  { "stsewd/isort.nvim" },
  {
    "ellisonleao/glow.nvim",
    config = function()
      require("glow").setup()
    end,
  },
  { "will133/vim-dirdiff" },
  {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  opts = {
     provider = "openai",
    openai = {
         model = "gpt-4o-mini",
       },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
}

