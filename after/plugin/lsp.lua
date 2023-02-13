-- LSP settings
-- TODO use 'mfussenegger/nvim-dap'
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
  nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end

-- Enable the following language servers
-- Feel free to add/remove any LSPs that you want here. They will automatically be installed
local servers = {
  -- clangd = {},
  -- gopls = {},
  pyright = {},
  sourcery = {},
  -- tsserver = {},

  sumneko_lua = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require("neodev").setup({})
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()
require("mason-null-ls").setup({
  ensure_installed = { "stylua", "prettier" },
  automatic_installation = false,
  automatic_setup = true, -- Recommended, but optional
})

local null_ls = require("null-ls")
local sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.prettier.with({
        prefer_local = "node_modules/.bin",
    }),
    null_ls.builtins.formatting.eslint.with({
        prefer_local = "node_modules/.bin",
    }),
    null_ls.builtins.formatting.fish_indent,
    null_ls.builtins.formatting.taplo,
    null_ls.builtins.formatting.terraform_fmt,
    null_ls.builtins.formatting.trim_newlines,
    null_ls.builtins.formatting.trim_whitespace,
    null_ls.builtins.formatting.uncrustify,
    null_ls.builtins.diagnostics.eslint.with({
        prefer_local = "node_modules/.bin",
    }),
    null_ls.builtins.diagnostics.flake8.with({
        prefer_local = ".venv/bin",
    }),
    null_ls.builtins.diagnostics.mypy.with({
        command={'python', '-m', 'mypy'}
    }),
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.diagnostics.hadolint,
    null_ls.builtins.code_actions.eslint.with({
        prefer_local = "node_modules/.bin",
    }),
    null_ls.builtins.code_actions.gitsigns,
}

null_ls.setup({
    sources = sources,
})

require("mason-null-ls").setup_handlers() -- If `automatic_setup` is true.

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    })
  end,
})

-- Turn on lsp status information
require("fidget").setup()

-- this is for diagnositcs signs on the line number column
-- use this to beautify the plain E W signs to more fun ones
-- !important nerdfonts needs to be setup for this to work in your terminal
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

-- -- Configure LSP through rust-tools.nvim plugin.
-- -- rust-tools will configure and enable certain LSP features for us.
-- -- See https://github.com/simrat39/rust-tools.nvim#configuration
-- local opts = {
--   tools = {
--     runnables = {
--       use_telescope = true,
--     },
--     inlay_hints = {
--       auto = true,
--       show_parameter_hints = false,
--       parameter_hints_prefix = "",
--       other_hints_prefix = "",
--     },
--   },
--
--   -- all the opts to send to nvim-lspconfig
--   -- these override the defaults set by rust-tools.nvim
--   -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
--   server = {
--     -- on_attach is a callback called when the language server attachs to the buffer
--     on_attach = on_attach,
--     settings = {
--       -- to enable rust-analyzer settings visit:
--       -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
--       ["rust-analyzer"] = {
--         imports = {
--           granularity = {
--             group = "module",
--           },
--           prefix = "self",
--         },
--         cargo = {
--           buildScripts = {
--             enable = true,
--           },
--         },
--         procMacro = {
--           enable = true
--         },
--         -- enable clippy on save
--         checkOnSave = {
--           command = "clippy",
--         },
--       },
--     },
--   },
-- }
--
-- require("rust-tools").setup(opts)
