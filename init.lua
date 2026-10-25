vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable 24-bit color
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true

vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-buffer" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/mfussenegger/nvim-lint" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/pwntester/octo.nvim" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/akinsho/bufferline.nvim" },
	{ src = "https://github.com/kylechui/nvim-surround" },
	{ src = "https://github.com/dangho1/theme-switcher.nvim" },
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
	{ src = "https://github.com/rose-pine/neovim" },
})

-- NVIM TREESITTER CONFIGURATION
local treesitter = require("nvim-treesitter")
treesitter.setup()

treesitter.install({
	"c",
	"cpp",
	"python",
	"lua",
	"javascript",
	"typescript",
	"html",
	"css",
	"rust",
	"zig",
	"odin",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"c",
		"cpp",
		"python",
		"lua",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"html",
		"css",
		"rust",
		"zig",
		"odin",
	},
	callback = function()
		-- syntax highlighting
		vim.treesitter.start()

		-- folding
		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo.foldlevel = 99

		-- treesitter identation
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
		selection_modes = {
			["@parameter.outer"] = "v",
			["@function.outer"] = "V",
			["@class.outer"] = "V",
		},
		include_surrounding_whitespace = false,
	},
	move = {
		set_jumps = true,
	},
})

local select = require("nvim-treesitter-textobjects.select")
local select_objects = {
	{ "f", "function", "Function" },
	{ "c", "class", "Class" },
	{ "p", "parameter", "Parameter" },
	{ "v", "call", "Call" },
	{ "i", "conditional", "Conditional" },
	{ "l", "loop", "Loop" },
	{ "b", "block", "Block" },
	{ "s", "statement", "Statement" },
	{ "r", "return", "Return" },
	{ "a", "assignment", "Assignment" },
}

for _, object in ipairs(select_objects) do
	local key, capture, label = object[1], object[2], object[3]
	vim.keymap.set({ "x", "o" }, "a" .. key, function()
		select.select_textobject("@" .. capture .. ".outer", "textobjects")
	end, { desc = "Select around " .. label })
	vim.keymap.set({ "x", "o" }, "i" .. key, function()
		select.select_textobject("@" .. capture .. ".inner", "textobjects")
	end, { desc = "Select inside " .. label })
end

local move = require("nvim-treesitter-textobjects.move")
local function map_move(key, method, capture, description)
	vim.keymap.set({ "n", "x", "o" }, key, function()
		move[method](capture, "textobjects")
	end, { desc = description })
end

local move_objects = {
	{ "f", "function", "Function" },
	{ "c", "class", "Class" },
	{ "p", "parameter", "Parameter" },
	{ "v", "call", "Call" },
	{ "i", "conditional", "Conditional" },
	{ "l", "loop", "Loop" },
	{ "b", "block", "Block" },
	{ "s", "statement", "Statement" },
	{ "r", "return", "Return" },
	{ "a", "assignment", "Assignment" },
}

for _, object in ipairs(move_objects) do
	local key, capture, label = object[1], object[2], object[3]
	local query = "@" .. capture .. ".outer"

	map_move("]" .. key, "goto_next_start", query, "Next " .. label .. " start")
	map_move("[" .. key, "goto_previous_start", query, "Previous " .. label .. " start")
	map_move("]" .. key:upper(), "goto_next_end", query, "Next " .. label .. " end")
	map_move("[" .. key:upper(), "goto_previous_end", query, "Previous " .. label .. " end")
end

-- VIM API LSP CONFIGURATION
require("lazydev").setup()

-- NVIM TREE CONFIGURATION
local nvim_tree = require("nvim-tree")
local api = require("nvim-tree.api")

nvim_tree.setup()

vim.keymap.set("n", "<leader>e", api.tree.toggle, {
	desc = "Toggle file tree",
})

vim.keymap.set("n", "<leader>d", function()
	vim.diagnostic.open_float(nil, {
		focus = true,
		scope = "cursor",
		border = "rounded",
		source = "if_many",
	})
end, {
	desc = "Show diagnostics",
})

vim.keymap.set("n", "<leader>lr", "<cmd>lsp restart<CR>", { desc = "Restart LSP" })

-- MASON CONFIGURATION
local mason = require("mason")
mason.setup()

-- CMP CONFIGURATION
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("*", {
	capabilities = capabilities,
})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-l>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "luasnip" },
	}),
})

-- LSP CONFIGURATIONS
vim.lsp.enable({
	"clangd",
	"pyright",
	"lua_ls",
	"ts_ls",
	"html",
	"cssls",
	"ols",
	"zls",
	"rust_analyzer",
})

-- FORMATTERS CONFIGURATIONS

local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		c = { "clang_format" },
		cpp = { "clang_format" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		rust = { "rustfmt" },
		zig = { "zigfmt" },
		odin = { "odinfmt" },
	},
})

vim.keymap.set({ "n", "v" }, "<leader>fb", function()
	conform.format({
		async = true,
		lsp_format = "fallback",
	})
end, { desc = "Format buffer" })

-- LINTER CONFIGURATIONS

local lint = require("lint")

lint.linters_by_ft = {
	c = { "clangtidy" },
	cpp = { "clangtidy" },
	python = { "ruff" },
	lua = { "luacheck" },
	javascript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescript = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	html = { "htmlhint" },
	css = { "stylelint" },
	rust = { "clippy" },
	zig = { "zlint" },
}

vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function()
		lint.try_lint()
	end,
})

vim.keymap.set("n", "<leader>lb", function()
	lint.try_lint()
end, { desc = "Run linter" })

-- TELESCOPE CONFIGURATIONS
local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({})

vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search text" })
vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>ss", builtin.lsp_document_symbols, { desc = "Document symbols" })
vim.keymap.set("n", "<leader>sw", builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })

-- WHICH KEY CONFIGURATIONS

local which_key = require("which-key")
which_key.setup()

which_key.add({
	{ "<leader>f", group = "Format" },
	{ "<leader>l", group = "LSP / Lint" },
	{ "<leader>s", group = "Search" },
	{ "<leader>g", group = "Git" },
	{ "<leader>h", group = "Git Hunk" },
	{ "<leader>t", group = "Toggle" },
	{ "<leader>x", group = "Trouble" },
	{ "<leader>b", group = "Buffers" },
	{ "<leader>c", group = "Colorscheme" },
})

vim.keymap.set("n", "<leader>?", function()
	which_key.show({ global = true })
end, { desc = "Show all keymaps" })

-- AUTOPAIRS CONFIGURATIONS
local npairs = require("nvim-autopairs")

npairs.setup({
	check_ts = true,
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- GITSIGNS CONFIGURATIONS

local gitsigns = require("gitsigns")
gitsigns.setup({
	current_line_blame = false,
	on_attach = function (bufnr)
		vim.keymap.set("n", "]c", function() if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gitsigns.nav_hunk("next") end end, { buffer = bufnr, desc = "Next Git hunk" })
		vim.keymap.set("n", "[c", function() if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gitsigns.nav_hunk("prev") end end, { buffer = bufnr, desc = "Previous Git hunk" })
		vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
		vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { buffer = bufnr, desc = "Stage hunk" })
		vim.keymap.set("n", "<leader>hS", gitsigns.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
		vim.keymap.set("n", "<leader>hR", gitsigns.reset_buffer, { buffer = bufnr, desc = "Stage buffer" })
		vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
		vim.keymap.set("n", "<leader>hb", gitsigns.blame_line, { buffer = bufnr, desc = "Blame line" })
		vim.keymap.set("n", "<leader>hd", gitsigns.diffthis , { buffer = bufnr, desc = "Diff file" })
		vim.keymap.set("n", "<leader>htb", gitsigns.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle line blame" })
	end
})

-- FUGITIVE CONFIGURATIONS

-- Status and repository overview
vim.keymap.set("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git status" })
vim.keymap.set("n", "<leader>gg", "<cmd>Git<cr>", { desc = "Git summary" })

-- Basic Git operations
vim.keymap.set("n", "<leader>ga", "<cmd>Git add %<cr>", { desc = "Stage current file" })
vim.keymap.set("n", "<leader>gA", "<cmd>Git add .<cr>", { desc = "Stage all files" })
vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git commit" })
vim.keymap.set("n", "<leader>gC", "<cmd>Git commit --amend<cr>", { desc = "Amend commit" })
vim.keymap.set("n", "<leader>gp", "<cmd>Git! push<cr>", { desc = "Git push" })
vim.keymap.set("n", "<leader>gP", "<cmd>Git! pull<cr>", { desc = "Git pull" })
vim.keymap.set("n", "<leader>gf", "<cmd>Git! fetch --all<cr>", { desc = "Git fetch all" })

-- Diffs
vim.keymap.set("n", "<leader>gd", "<cmd>Gdiffsplit<cr>", { desc = "Diff current file" })
vim.keymap.set("n", "<leader>gD", "<cmd>Gvdiffsplit<cr>", { desc = "Vertical diff current file" })
vim.keymap.set("n", "<leader>gh", "<cmd>Git diff HEAD<cr>", { desc = "Diff against HEAD" })
vim.keymap.set("n", "<leader>gH", "<cmd>Git diff --cached<cr>", { desc = "Diff staged changes" })

-- History and blame
vim.keymap.set("n", "<leader>gl", "<cmd>Git log<cr>", { desc = "Git log" })
vim.keymap.set("n", "<leader>gL", "<cmd>Gclog<cr>", { desc = "File commit history" })
vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Git blame" })

-- Branches and remotes
vim.keymap.set("n", "<leader>gB", "<cmd>Git branch<cr>", { desc = "List branches" })
vim.keymap.set("n", "<leader>go", "<cmd>Git checkout<cr>", { desc = "Checkout branch" })
vim.keymap.set("n", "<leader>gr", "<cmd>Git remote -v<cr>", { desc = "List remotes" })

-- Stash
vim.keymap.set("n", "<leader>gss", "<cmd>Git stash<cr>", { desc = "Stash changes" })
vim.keymap.set("n", "<leader>gsp", "<cmd>Git stash pop<cr>", { desc = "Pop stash" })
vim.keymap.set("n", "<leader>gsl", "<cmd>Git stash list<cr>", { desc = "List stashes" })

-- Conflict resolution and quickfix
vim.keymap.set("n", "<leader>gM", "<cmd>Git mergetool<cr>", { desc = "Open merge tool" })
vim.keymap.set("n", "<leader>gq", "<cmd>copen<cr>", { desc = "Open Git quickfix list" })
vim.keymap.set("n", "<leader>gn", "<cmd>cnext<cr>", { desc = "Next Git conflict" })
vim.keymap.set("n", "<leader>gN", "<cmd>cprevious<cr>", { desc = "Previous Git conflict" })

-- GitHub/browser integration
vim.keymap.set("n", "<leader>gx", "<cmd>GBrowse<cr>", { desc = "Open file online" })

-- Search the repository with git grep
vim.keymap.set("n", "<leader>g/", "<cmd>Ggrep ", { desc = "Search repository with git grep" })

-- OCTO CONFIGURATION

local octo = require("octo")

octo.setup({
	picker = "telescope",
	enable_builtin = true,
})

vim.keymap.set("n", "<leader>oi", "<cmd>Octo issue list<cr>", { desc = "List GitHub issues" })
vim.keymap.set("n", "<leader>op", "<cmd>Octo pr list<cr>", { desc = "List GitHub pull requests" })
vim.keymap.set("n", "<leader>od", "<cmd>Octo discussion list<cr>", { desc = "List GitHub discussions" })
vim.keymap.set("n", "<leader>on", "<cmd>Octo notification list<cr>", { desc = "List GitHub notifications" })

vim.keymap.set("n", "<leader>os", function()
	require("octo.utils").create_base_search_command({
		include_current_repo = true,
	})
end, { desc = "Search GitHub" })

-- TROUBLE CONFIGURATION

local trouble = require("trouble")

trouble.setup({
	auto_preview = true,
	follow = true,
	indent_guides = true,
	multiline = true,
})

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP references and definitions" })
vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Document symbols" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })

-- LUALINE CONFIGURATION

local lualine = require("lualine")

lualine.setup({
	options = {
		theme = "auto",
		icons_enabled = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = true,
		always_show_tabline = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", path = 1 } },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- BUFFERLINE CONFIGURATION

local bufferline = require("bufferline")

bufferline.setup({
	options = {
		mode = "buffers",
		numbers = "ordinal",
		close_command = "bdelete! %d",
		right_mouse_command = "bdelete! %d",
		separator_style = "slant",
		always_show_bufferline = true,
		show_buffer_close_icons = true,
		show_close_icon = true,
		diagnostics = "nvim_lsp",
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				text_align = "left",
				separator = true,
			},
		},
	},
})

vim.keymap.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>ba", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Close buffers to the left" })
vim.keymap.set("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Close buffers to the right" })

-- NVIM-SURROUND CONFIGURATION

local surround = require("nvim-surround")

surround.setup({
	aliases = {
		a = ">",
		b = ")",
		B = "}",
		r = "]",
		q = { '"', "'", "`" },
		s = { "}", "]", ")", ">", '"', "'", "`" },
	},
	highlight = {
		duration = 0,
	},
	move_cursor = "begin",
	indent_lines = function(start, stop)
		local buffer = vim.bo
		if start < stop and (buffer.equalprg ~= "" or buffer.indentexpr ~= "" or buffer.cindent or buffer.smartindent or buffer.lisp) then
			vim.cmd(string.format("silent normal! %dG=%dG", start, stop))
		end
	end,
})

-- THEME SWITCHER CONFIGURATION

local theme_switcher = require("theme-switcher")

theme_switcher.setup({
	keymap = "<leader>cs",
	save_path = vim.fn.stdpath("config") .. "/lua/default-colorscheme.lua",
	telescope_opts = {
		enable_preview = true,
		layout_config = {
			width = 0.8,
			height = 0.8,
		},
	},
	notify = true,
})

local colorscheme_ok, colorscheme = pcall(require, "default-colorscheme")
if colorscheme_ok then
	vim.cmd.colorscheme(colorscheme)
end
