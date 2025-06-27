local lspconfig = require "lspconfig"

local M = {}
local map = vim.keymap.set

-- export on_attach & capabilities
M.on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")

  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
  map("n", "<leader>ra", require "nvchad.lsp.renamer", opts "NvRenamer")
end

-- disable semanticTokens
M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

M.defaults = function()
  dofile(vim.g.base46_cache .. "lsp")
  require("nvchad.lsp").diagnostic_config()

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      M.on_attach(_, args.buf)
    end,
  })

  local lua_lsp_settings = {
    Lua = {
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/luv/library",
        },
      },
    },
  }

  -- Support 0.10 temporarily

  if vim.lsp.config then
    vim.lsp.config("*", { capabilities = M.capabilities, on_init = M.on_init })
    vim.lsp.config("lua_ls", { settings = lua_lsp_settings })
    vim.lsp.enable "lua_ls"
  else
    lspconfig.lua_ls.setup {
      capabilities = M.capabilities,
      on_init = M.on_init,
      settings = lua_lsp_settings,
    }
  end
end

-- EXAMPLE
local servers = { "html", "cssls", "pylsp", "gopls", "ts_ls" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
  }
end

-- Typescript personalized config
lspconfig.ts_ls.setup {
  on_attach = function(client, bufnr)
    M.on_attach(client, bufnr)
    -- Set up format on save if you want ts_ls to handle formatting
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format { timeout_ms = 2000 }
      end,
    })
  end,
  on_init = M.on_init,
  capabilities = M.capabilities,
  settings = {
    typescript = {
      preferences = {
        importModuleSpecifier = "non-relative",
      },
    },
    diagnostics = {
      enable = true,
    },
  },
  init_options = {
    preferences = {
      importModuleSpecifier = "non-relative",
    },
  },
}

-- golang personalized config
lspconfig.gopls.setup {
  on_attach = function(client, bufnr)
    M.on_attach(client, bufnr)
    -- Set up format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format { timeout_ms = 2000 }
      end,
    })
  end,
  on_init = M.on_init,
  capabilities = M.capabilities,
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}

-- python personalized config
lspconfig.pylsp.setup {
  on_attach = M.on_attach,
  -- on_attach = function(client, bufnr)
  --   M.on_attach(client, bufnr)
  --   -- Set up format on save
  --   vim.api.nvim_create_autocmd("BufWritePre", {
  --     buffer = bufnr,
  --     callback = function()
  --       vim.lsp.buf.format({ timeout_ms = 2000 })
  --     end,
  --   })
  -- end,
  on_init = M.on_init,
  capabilities = M.capabilities,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { "W391", "E302" },
          maxLineLength = 350,
        },
        pylint = {
          enabled = true,
          executable = "pylint",
          args = { "--rcfile", vim.fn.getcwd() .. "/.pylintrc" },
        },
      },
    },
    black = {
      enabled = true,
      line_length = 150,
    },
  },
}

-- Rust personalized config
lspconfig.rust_analyzer.setup {
  on_attach = function(client, bufnr)
    M.on_attach(client, bufnr)
    -- Set up format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format { timeout_ms = 2000 }
      end,
    })
  end,
  on_init = M.on_init,
  capabilities = M.capabilities,
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "self",
      },
      cargo = {
        loadOutDirsFromCheck = true,
      },
      procMacro = {
        enable = true,
      },
      checkOnSave = {
        command = "clippy",
      },
      diagnostics = {
        enable = true,
      },
    },
  },
}

return M
