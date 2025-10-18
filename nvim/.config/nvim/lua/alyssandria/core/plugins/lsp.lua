-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    "saghen/blink.cmp",
  },

  -- ✅ Instead of `config = function()`, use `opts` to extend LazyVim’s LSP setup
  opts = function(_, opts)
    ----------------------------------------------------------------
    -- 🔧 CAPABILITIES
    ----------------------------------------------------------------
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    ----------------------------------------------------------------
    -- 🧠 LSP SERVER SETTINGS
    ----------------------------------------------------------------
    opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
      lua_ls = {
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
          },
        },
      },
    })

    ----------------------------------------------------------------
    -- 🔍 LSP ATTACH (CUSTOM KEYMAPS)
    ----------------------------------------------------------------
    local augroup = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
      group = augroup,
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        local telescope = require("telescope.builtin")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
        map("gd", telescope.lsp_definitions, "Goto Definition")
        map("gr", telescope.lsp_references, "Goto References")
        map("gi", telescope.lsp_implementations, "Goto Implementation")
        map("gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("gO", telescope.lsp_document_symbols, "Document Symbols")
        map("gW", telescope.lsp_dynamic_workspace_symbols, "Workspace Symbols")
        map("gt", telescope.lsp_type_definitions, "Goto Type Definition")
        map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
        map("]d", vim.diagnostic.goto_next, "Next Diagnostic")

        -- Inlay hints toggle
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method("textDocument/inlayHint") then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end, "Toggle Inlay Hints")
        end
      end,
    })

    ----------------------------------------------------------------
    -- ⚙️ DIAGNOSTIC SETTINGS
    ----------------------------------------------------------------
    vim.diagnostic.config({
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = "󰋽 ",
          [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
      } or {},
      virtual_text = {
        source = "if_many",
        spacing = 2,
        format = function(diagnostic)
          return diagnostic.message
        end,
      },
    })

    ----------------------------------------------------------------
    -- 🔧 AUTO-INSTALL SERVERS VIA MASON
    ----------------------------------------------------------------
    local ensure_installed = vim.tbl_keys(opts.servers or {})
    vim.list_extend(ensure_installed, { "stylua" })
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
  end,
}
