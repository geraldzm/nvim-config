dofile(vim.g.base46_cache .. "git")

return {
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "󰍵" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "│" },
	},

	on_attach = function(bufnr)
		require("mappings").gitsigns(bufnr)
	end,
}
