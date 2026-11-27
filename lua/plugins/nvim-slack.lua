return {
	{
		"geraldzm/nvim-slack",
		cmd = "Slack",
		config = function()
			require("nvim-slack").setup({})
		end,
	},
}
