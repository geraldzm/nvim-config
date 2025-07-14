return {
	{
		"stevearc/oil.nvim",
		opts = {},
		lazy = false,
		config = function()
			require("oil").setup(require("configs.oil"))
		end,
	},
}

