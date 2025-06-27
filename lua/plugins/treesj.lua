return {
	"Wansmer/treesj",
	lazy = false,
	dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesj").setup(require("configs.treesj"))
  end,
}
