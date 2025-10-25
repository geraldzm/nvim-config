return {
	-- The width of the focused window that will be centered. When the terminal width is less than the `width` option, the side buffers won't be created.
	---@type integer|"textwidth"|"colorcolumn"
	width = 110,
	-- Adds autocmd (@see `:h autocmd`) which aims at automatically enabling the plugin.
	---@type table
	autocmds = {
		-- When `true`, enables the plugin when you start Neovim.
		-- If the main window is  a side tree (e.g. NvimTree) or a dashboard, the command is delayed until it finds a valid window.
		-- The command is cleaned once it has successfuly ran once.
		-- When `safe`, debounces the plugin before enabling it.
		-- This is recommended if you:
		--  - use a dashboard plugin, or something that also triggers when Neovim is entered.
		--  - usually leverage commands such as `nvim +line file` which are executed after Neovim has been entered.
		---@type boolean | "safe"
		enableOnVimEnter = true,
		-- When `true`, enables the plugin when you enter a new Tab.
		-- note: it does not trigger if you come back to an existing tab, to prevent unwanted interfer with user's decisions.
		---@type boolean
		enableOnTabEnter = false,
		-- When `true`, reloads the plugin configuration after a colorscheme change.
		---@type boolean
		reloadOnColorSchemeChange = false,
		-- When `true`, entering one of no-neck-pain side buffer will automatically skip it and go to the next available buffer.
		---@type boolean
		skipEnteringNoNeckPainBuffer = false,
	},
	--- Common options that are set to both side buffers.
	--- See |NoNeckPain.bufferOptions| for option scoped to the `left` and/or `right` buffer.
	---@type table
	buffers = {
		scratchPad = {
			enabled = false,
		},
		right = {
			enabled = false,
		},
		bo = {
			filetype = "md",
		},
	},
	debug = true,
}
