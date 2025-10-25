dofile(vim.g.base46_cache .. "telescope")

-- Override border colors after base46 loads
vim.schedule(function()
	vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#595959" })
	vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#595959" })
	vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#595959" })
	vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#595959" })
end)

return {
	defaults = {
		prompt_prefix = "",
		selection_caret = " ",
		entry_prefix = " ",
		-- sorting_strategy = "ascending",
		layout_config = {
			horizontal = {
				prompt_position = "bottom",
				preview_width = 0.55,
			},
			width = 0.75,
			height = 0.80,
		},
		mappings = {
			n = { ["q"] = require("telescope.actions").close },
		},
		preview = {
			mime_hook = function(filepath, bufnr, opts)
				local is_image = function(Imgfilepath)
					local image_extensions = { "png", "jpg" } -- Supported image formats
					local split_path = vim.split(Imgfilepath:lower(), ".", { plain = true })
					local extension = split_path[#split_path]
					return vim.tbl_contains(image_extensions, extension)
				end
				if is_image(filepath) then
					local term = vim.api.nvim_open_term(bufnr, {})
					local function send_output(_, data, _)
						for _, d in ipairs(data) do
							vim.api.nvim_chan_send(term, d .. "\r\n")
						end
					end
					vim.fn.jobstart({
						"catimg",
						filepath, -- Terminal image viewer command
					}, { on_stdout = send_output, stdout_buffered = true, pty = true })
				else
					require("telescope.previewers.utils").set_preview_message(
						bufnr,
						opts.winid,
						"Binary cannot be previewed"
					)
				end
			end,
		},
	},
	extensions_list = { "themes", "terms" },
	extensions = {},
}
