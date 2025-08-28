return {
	{
		"shortcuts/no-neck-pain.nvim",
		version = "*",
		opts = {},
		lazy = false,
		config = function()
			require("no-neck-pain").setup(require("configs.no-neck-pain"))
		end,
	},
}
