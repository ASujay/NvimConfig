local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.find_files, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.find_files, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.find_files, { desc = 'Telescope help tags' })

