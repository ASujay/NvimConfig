-- load adding configs
require('maps')
require('telescope_config')
require('mason_config')
require('treesitter-config')
require('lsp-config')
require('colorscheme-config')
require('lualine-config')
require('nvimtree-config')
require('set')
-- This will contain the packer statements

function SetScheme()
    vim.api.nvim_set_hl(0, "Normal", {bg="none"})
    vim.api.nvim_set_hl(0, "NormalFloat", {bg="none"})

    -- set the theme
    vim.g.material_style = "deep ocean"
end
SetScheme()

vim.cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
	-- Packer install
	use 'wbthomason/packer.nvim'
	
	-- Treesitter config
	use {
		'nvim-treesitter/nvim-treesitter', 
		run = ':TSUpdate'
	}

	-- Telescope config
	use {
  		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		-- or                            , branch = '0.1.x',
  		requires = { {'nvim-lua/plenary.nvim'} }
	}

	-- Mason config
	use {
    		"williamboman/mason.nvim",
    		run = ":MasonUpdate" 
	}

	-- Nvim-dap
	use 'mfussenegger/nvim-dap'

	use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
    use 'williamboman/mason-lspconfig.nvim'
  	use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-nvim-lua'
  	use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  	use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  	use 'L3MON4D3/LuaSnip' -- Snippets plugin
    use 'rafamadriz/friendly-snippets'

	-- lualine
	use {
  		'nvim-lualine/lualine.nvim',
  		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}
	use 'marko-cerovac/material.nvim'
	use 'nvim-tree/nvim-tree.lua'
end)
