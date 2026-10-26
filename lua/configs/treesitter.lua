pcall(function()
	dofile(vim.g.base46_cache .. "syntax")
	dofile(vim.g.base46_cache .. "treesitter")
end)

require("nvim-treesitter").install({
	"lua",
	"luadoc",
	"printf",
	"vim",
	"vimdoc",
	"query",
	"markdown",
	"markdown_inline",
	"bash",
	"json",
	"make",
	"html",
	"css",
	"javascript",
	"typescript",
	"tsx",
	"python",
	"go",
	"gomod",
	"rust",
	"c",
	"cpp",
	"terraform",
	"hcl",
})

-- highlighting is provided by neovim, indentation by nvim-treesitter (experimental)
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
	callback = function(args)
		if pcall(vim.treesitter.start, args.buf) then
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
