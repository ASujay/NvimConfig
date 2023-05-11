local builtin = require('telescope.builtin')

require('telescope').setup{
	defaults = {
		file_ignore_patterns = {
			"pack"
		},
		sorting_strategy = "ascending"
	}
}

--keymaps - telescope fuzzy finding
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})

--keymaps - lsp functionality
vim.keymap.set('n', '<leader>gr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>gic', builtin.lsp_incoming_calls, {})
vim.keymap.set('n', '<leader>goc', builtin.lsp_outgoing_calls, {})
vim.keymap.set('n', '<leader>gs', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>gws', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>gds', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>gi', builtin.lsp_implementations, {})
vim.keymap.set('n', '<leader>gd', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>gtp', builtin.lsp_type_definitions, {})

--keymaps - treesitter picker
vim.keymap.set('n', '<leader>lf', builtin.treesitter, {})
