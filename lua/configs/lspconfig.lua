local M = {}
local map = vim.keymap.set

-- export on_attach & capabilities
M.on_attach = function(_, bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = "LSP " .. desc }
	end

	map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
	map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))

	map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
	map("n", "<leader>ra", require("nvchad.lsp.renamer"), opts("NvRenamer"))
end

-- format on save, cleared per buffer so re-attaching doesn't stack autocmds
local format_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })
M.format_on_save = function(bufnr)
	vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = format_group,
		buffer = bufnr,
		callback = function()
			vim.lsp.buf.format({ timeout_ms = 2000 })
		end,
	})
end

-- disable semanticTokens
M.on_init = function(client, _)
	if client:supports_method("textDocument/semanticTokens") then
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
					vim.fn.expand("$VIMRUNTIME/lua"),
					vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
					vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
					"${3rd}/luv/library",
				},
			},
		},
	}

	vim.lsp.config("*", { capabilities = M.capabilities, on_init = M.on_init })
	vim.lsp.config("lua_ls", { settings = lua_lsp_settings })
	vim.lsp.enable("lua_ls")
end

-- EXAMPLE
local servers = { "html", "cssls", "pylsp", "gopls", "ts_ls", "clangd", "rust_analyzer", "terraformls" }

-- lsps with default config
for _, lsp in ipairs(servers) do
	vim.lsp.config(lsp, {
		on_attach = M.on_attach,
		on_init = M.on_init,
		capabilities = M.capabilities,
	})
end

-- Typescript: ts_ls needs the project's tsserver.js (TypeScript < 7), tsc serves everything else
local function has_tsserver(root)
	return vim.uv.fs_stat(vim.fs.joinpath(root, "node_modules/typescript/lib/tsserver.js")) ~= nil
end

local ts_ls_default = assert(vim.lsp.config.ts_ls)
local tsc_default = assert(vim.lsp.config.tsc)

local ts_settings = {
	typescript = {
		preferences = {
			importModuleSpecifier = "non-relative",
		},
	},
}

local function ts_on_attach(client, bufnr)
	M.on_attach(client, bufnr)
	M.format_on_save(bufnr)
end

vim.lsp.config("ts_ls", {
	on_attach = ts_on_attach,
	on_init = M.on_init,
	capabilities = M.capabilities,
	root_dir = function(bufnr, on_dir)
		ts_ls_default.root_dir(bufnr, function(root)
			if has_tsserver(root) then
				on_dir(root)
			end
		end)
	end,
	settings = ts_settings,
	init_options = {
		preferences = {
			importModuleSpecifier = "non-relative",
		},
	},
})

vim.lsp.config("tsc", {
	on_attach = ts_on_attach,
	on_init = M.on_init,
	capabilities = M.capabilities,
	cmd = tsc_default.cmd, -- shares a binary cache with tsc_default.root_dir
	root_dir = function(bufnr, on_dir)
		tsc_default.root_dir(bufnr, function(root)
			if not has_tsserver(root) then
				on_dir(root)
			end
		end)
	end,
	settings = ts_settings,
})

-- golang personalized config
vim.lsp.config("gopls", {
	on_attach = function(client, bufnr)
		M.on_attach(client, bufnr)
		M.format_on_save(bufnr)
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
})

-- python personalized config
vim.lsp.config("pylsp", {
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
})

-- Rust personalized config
vim.lsp.config("rust_analyzer", {
	on_attach = function(client, bufnr)
		M.on_attach(client, bufnr)
		M.format_on_save(bufnr)
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
})
vim.lsp.enable({ "html", "cssls", "pylsp", "gopls", "ts_ls", "tsc", "clangd", "rust_analyzer", "terraformls" })

return M
