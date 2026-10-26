-- restrict telescope searches to a set of picked directories
local M = {
	enabled = false,
	dirs = {},
}

local function skip(dir)
	local name = vim.fs.basename(dir)
	return not vim.startswith(name, ".") and name ~= "node_modules"
end

local function notify()
	vim.notify("Search scope: " .. (M.enabled and table.concat(M.dirs, ", ") or "everywhere"))
end

M.pick = function()
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local dirs = {}
	for name, type in vim.fs.dir(".", { depth = math.huge, skip = skip }) do
		if type == "directory" and skip(name) then
			table.insert(dirs, name)
		end
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Search scope (Tab to select several)",
			finder = require("telescope.finders").new_table({ results = dirs }),
			sorter = require("telescope.config").values.generic_sorter({}),
			attach_mappings = function(bufnr)
				actions.select_default:replace(function()
					local selected = action_state.get_current_picker(bufnr):get_multi_selection()
					if #selected == 0 then
						selected = { action_state.get_selected_entry() }
					end
					actions.close(bufnr)

					M.dirs = vim.tbl_map(function(entry)
						return entry[1]
					end, selected)
					M.enabled = true
					notify()
				end)
				return true
			end,
		})
		:find()
end

M.toggle = function()
	if #M.dirs == 0 then
		return M.pick()
	end
	M.enabled = not M.enabled
	notify()
end

-- adds the picked directories to a telescope picker's opts when the scope is enabled
M.opts = function(opts)
	if M.enabled then
		opts.search_dirs = M.dirs
	end
	return opts
end

return M
