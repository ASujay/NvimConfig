--------------------------------------------------------------------------
-- This should be done before loading any configuration for the plugins --
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
--vim.cmd("hi Normal guibg=NONE ctermbg=NONE") -- Makes the background transparent
--vim.cmd("hi NormalNC guibg=NONE ctermbg=NONE") -- For inactive windows
vim.diagnostic.config({
    virtual_text = false,
    float = {
        border = "rounded",
        source = "always",
        focusable = true,
        max_width = 80,
        wrap = true,
    },
});
--------------------------------------------------------------------------

require("keymap")
require("nvim_tree")
require("mason-config")
require("telescope-config")
require("toggleterm-config")
require("lsp-config")
require("indent-blackline")

require('packer').startup(function(use)
	-- Packer install
	use 'wbthomason/packer.nvim'
	-- Nvim tree
	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional
		},
	}

    -- lualine
    use {
        'nvim-lualine/lualine.nvim',
        requires = {'nvim-tree/nvim-web-devicons', opt = true}
    }

    -- nvim v0.8.0
    use {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    }
    use {
        "williamboman/mason.nvim"
    }

    use 'nvim-tree/nvim-web-devicons'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use {
        "akinsho/toggleterm.nvim", tag = '*'
    }
    use "neovim/nvim-lspconfig"

    use({
	    "L3MON4D3/LuaSnip",
	    -- follow latest release.
	    tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	    -- install jsregexp (optional!:).
	    run = "make install_jsregexp"
    })
    use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-nvim-lua'
  	use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  	use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    use "lukas-reineke/indent-blankline.nvim"
    use "rebelot/kanagawa.nvim"
    -- These optional plugins should be loaded directly because of a bug in Packer lazy loading
    use 'lewis6991/gitsigns.nvim' -- OPTIONAL: for git status
    use 'romgrk/barbar.nvim'
    use {'nyoom-engineering/oxocarbon.nvim'}
end)
vim.opt.background = "dark"
vim.cmd("colorscheme oxocarbon")
