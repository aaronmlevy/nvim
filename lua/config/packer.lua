-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use( { 
		'eddyekofo94/gruvbox-flat.nvim',
		config = function()
			vim.g.gruvbox_flat_style = "dark" 
			vim.cmd('colorscheme gruvbox-flat')
		end
	})


	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}
	use({
	  "nvim-treesitter/nvim-treesitter-textobjects",
	  after = "nvim-treesitter",
	  requires = "nvim-treesitter/nvim-treesitter",
	})
    use("theprimeagen/harpoon")
	use("tpope/vim-fugitive")
	use("github/copilot.vim")
	use('nvim-lua/plenary.nvim')

	use {
		'CopilotC-Nvim/CopilotChat.nvim',
		branch = 'canary',
		config = function()
			-- Configuration options go here
			require('CopilotChat').setup({
				debug = true  -- Enable debugging
				-- Add more configuration options as needed
			})
		end,
		requires = {
			{'zbirenbaum/copilot.lua'},  -- Dependency: copilot.lua
			{'nvim-lua/plenary.nvim'}    -- Dependency: plenary.nvim
		}
	}

	use {
		"kiyoon/jupynium.nvim",
		run = "pip3 install --user jupynium",
	}
	use { "rcarriga/nvim-notify" }   -- optional
	use { "stevearc/dressing.nvim" } -- optional, UI for :JupyniumKernelSelect
	use { "preservim/nerdcommenter" }
	--use {
		--'SUSTech-data/neopyter',
		--config = function()
			---- Require the module and configure the options
			--local neopyter = require('neopyter')
			--neopyter.setup({
				--mode = "direct",
				--remote_address = "10.98.14.121:9001",
				--file_pattern = { "*.ju.*" },
				--highlight = {
					--enable = true,
					--shortsighted = false,
				--}
			--})
		--end
	--}
	--use("AbaoFromCUG/websocket.nvim")
	use('jpalardy/vim-slime')
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		requires = {
			{'neovim/nvim-lspconfig'},
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'L3MON4D3/LuaSnip'},
		}
	}

	use('preservim/nerdtree')
	use( "williamboman/mason.nvim" )
	use( "williamboman/mason-lspconfig.nvim" )
	--use( "majutsushi/tagbar" )
	use('romainl/vim-cool')
	use( "vim-airline/vim-airline" )
	use( "vim-airline/vim-airline-themes" )
	use( "qpkorr/vim-bufkill" )
	use( "easymotion/vim-easymotion" )
	use( "airblade/vim-gitgutter" )
	use( 'mg979/vim-visual-multi')
	use( 'hanschen/vim-ipython-cell')
    use( 'liuchengxu/vista.vim')
    use( 'stsewd/isort.nvim' )
end)

