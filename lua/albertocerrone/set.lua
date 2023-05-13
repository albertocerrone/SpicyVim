-- [[ Setting options ]]
-- See `:help vim.o`

-- Relative line numbers
vim.o.nu = true
vim.o.relativenumber = true

-- Go to prev/next line if at the end of the line
vim.o.whichwrap = 'b,s,<,>,h,l,[,]'

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 50
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Set scrolloff
vim.o.scrolloff = 12

-- Open new split below and right
vim.o.splitbelow = true
vim.o.splitright = true

-- Cursorline highlighting control
--  Only have it on in the active buffer
local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(event, value, pattern)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = function()
      vim.opt_local.cursorline = value
    end,
  })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")

vim.opt.shada = { "!", "'1000", "<50", "s10", "h" }

-- Folding
vim.opt.foldmethod='expr'
vim.opt.foldexpr='nvim_treesitter#foldexpr()'
vim.opt.foldenable=false       -- Disable folding at startup.
