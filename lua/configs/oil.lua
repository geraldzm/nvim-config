return {
	-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
	-- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
	default_file_explorer = true,
	-- See :help oil-columns
	columns = {
		-- "icon",
		-- "permissions",
		-- "size",
		-- "mtime",
	},
	-- See :help oil-actions for a list of all available actions
	keymaps = {
		["`"] = { "actions.cd", mode = "n" },
		["<CR>"] = "actions.select",
		["<C-p>"] = "actions.preview",
		["<C-c>"] = { "actions.close", mode = "n" },
		["n"] = { "actions.parent", mode = "n" },
		["m"] = { "actions.open_cwd", mode = "n" },
		["g?"] = { "actions.show_help", mode = "n" },
		["gs"] = { "actions.change_sort", mode = "n" },
		["gx"] = "actions.open_external",
		["g."] = { "actions.toggle_hidden", mode = "n" },
	},
	use_default_keymaps = false,
}

