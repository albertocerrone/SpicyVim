local spectre = require "spectre"
spectre.setup()

vim.keymap.set("n", "<leader>sr", function() spectre.open() end, { desc = "[S]earch and [R]eplace globaly" })

