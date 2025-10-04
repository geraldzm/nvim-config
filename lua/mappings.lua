local M = {}

local map = vim.keymap.set

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

map({ "n", "x" }, "<leader>fm", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })
map("n", "<PageDown>d", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Go to next diagnostic" })

map("n", "<PageUp>d", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Go to previous diagnostic" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>ft", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })

map("n", "<leader>th", function()
	require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
	"n",
	"<leader>fa",
	"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
	{ desc = "telescope find all files" }
)

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

map({ "n", "t" }, "<A-v>", function()
	require("nvchad.term").toggle({ pos = "vsp", id = "vtoggleTerm" })
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
	require("nvchad.term").toggle({ pos = "sp", id = "htoggleTerm" })
end, { desc = "terminal toggleable horizontal term" })

map({ "n", "t" }, "<A-m>", function()
	require("nvchad.term").toggle({ pos = "float", id = "floatTerm" })
end, { desc = "terminal toggle floating term" })

map("n", "<A-t>", "<cmd>term<CR>", { desc = "open terminal in current window" })

-------------------------------

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- move highlighted things
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor in the middle when half page jumping
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- keep search tearms in the middle when
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("n", "<leader>pv", vim.cmd.Oil, { desc = "Open Oil" })

map("n", "#", function()
	vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
	vim.opt.hlsearch = true
end, { desc = "Highlight word under cursor (no jump)" })

-- Toggle line wrapping
map("n", "<leader>tw", function()
	vim.wo.wrap = not vim.wo.wrap
	print("Line wrap: " .. (vim.wo.wrap and "ON" or "OFF"))
end, { desc = "Toggle line wrap" })

-- Replace selected instances with custom text
map("v", "<space>r", 'y:%s#\\V<C-r>"##g<left><left>', { desc = "Replace all instances (type replacement)" })
map("v", "<space>R", 'y:%s#\\V<C-r>"##gc<left><left><left>', { desc = "Replace all instances (type replacement)" })

-- Harpoon mappings
local harpoon = require("harpoon")
-- Add file to harpoon
map("n", "<leader>ha", function()
	harpoon:list():add()
end, { desc = "Harpoon add file" })
-- Toggle quick menu
map("n", "<leader>hm", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })
-- Navigate to files
map("n", "<A-j>", function()
	harpoon:list():select(1)
end, { desc = "Harpoon file 1" })
map("n", "<A-k>", function()
	harpoon:list():select(2)
end, { desc = "Harpoon file 2" })
map("n", "<A-u>", function()
	harpoon:list():select(3)
end, { desc = "Harpoon file 3" })
map("n", "<A-i>", function()
	harpoon:list():select(4)
end, { desc = "Harpoon file 4" })

-- Optional: Telescope integration
map("n", "<leader>ht", function()
	require("telescope").extensions.harpoon.marks()
end, { desc = "Harpoon telescope" })

-- Cammelcase and snake case
map("v", "<leader>cs", [[:s/\%V\v([a-z])([A-Z])/\1_\L\2/g<CR>]], { desc = "CamelCase to snake_case" })
map("v", "<leader>sc", [[:s/\%V\v_([a-z])/\U\1/g<CR>]], { desc = "snake_case to CamelCase" })

-- Buffer
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })
map("n", "<leader>x", "<cmd>bd<CR>", { desc = "buffer delete" })

map("n", "<leader>sm", "<cmd>TSJToggle<cr>", { desc = "Toggle node under cursor" })
map("n", "<leader>sj", "<cmd>TSJJoin<cr>", { desc = "Join node under cursor" })
map("n", "<leader>ss", "<cmd>TSJSplit<cr>", { desc = "Split node under cursor" })

-- Git
--  git status
map("n", "<leader>gs", ":tab Git<CR>", { desc = "Git status" })
--  git commit
map("n", "<leader>gc", ":tab Git commit<CR>", { desc = "Git commit" })
--  git push
map("n", "<leader>gpp", ":Git push<CR>", { desc = "Git push" })
--  git pull
map("n", "<leader>gpl", ":Git pull<CR>", { desc = "Git pull" })
--  git fetch
map("n", "<leader>gf", ":Git fetch<CR>", { desc = "Git fetch" })
--  git stash
map("n", "<leader>gh", ":Git stash<CR>", { desc = "Git log" })
--  git log
map("n", "<leader>gl", ":tab Git log<CR>", { desc = "Git log" })

-- map("n", "<leader>gd", ":Gdiffsplit<CR>", { desc = "Git diff split" })
-- map("n", "<leader>gvd", ":Gvdiffsplit<CR>", { desc = "Git vertical diff split" })
map("n", "<leader>ge", ":Git blame<CR>", { desc = "Git blame" })

--  git branch
map("n", "<leader>gb", ":tab Git branch<CR>", { desc = "Git branch" })
--  git checkout
map("n", "<leader>go", ":Git checkout", { desc = "Git checkout" })

-- File operations
--  git add
map("n", "<leader>ga", ":Gwrite<CR>", { desc = "Git add" })

M.gitsigns = function(bufnr)
	local gs = package.loaded.gitsigns

	local function localMap(mode, l, r, opts)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, l, r, opts)
	end

	localMap("n", "<leader>ph", gs.preview_hunk, { desc = "Preview git hunk" })
	localMap("n", "<leader>rh", gs.reset_hunk, { desc = "Reset git hunk" })
	localMap("n", "<End>h", gs.next_hunk, { desc = "Next git hunk" })
	localMap("n", "<Home>h", gs.prev_hunk, { desc = "Previous git hunk" })
end

-- copy file path relative to project root (cwd)
map("n", "<leader>pr", "<cmd>let @+ = fnamemodify(expand('%:p'), ':.')<CR>", { desc = "netrw: copy path from project root" })
-- copy absolute file path (from PC root)
map("n", "<leader>pa", "<cmd>let @+ = expand('%:p')<CR>", { desc = "netrw: copy absolute path" })

-- Tmux navigation
map("n", "<c-h>", "<cmd>TmuxNavigateLeft<CR>")
map("n", "<c-j>", "<cmd>TmuxNavigateDown<CR>")
map("n", "<c-k>", "<cmd>TmuxNavigateUp<CR>")
map("n", "<c-l>", "<cmd>TmuxNavigateRight<CR>")
map("n", "<c-\\>", "<cmd>TmuxNavigatePrevious<CR>")

-- undo tree
map("n", "<leader>tu", "<cmd>UndotreeToggle<CR>", { desc = "Toggle undo tree" })

return M
