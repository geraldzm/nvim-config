return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require "harpoon"

      -- REQUIRED
      harpoon:setup {
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
          key = function()
            return vim.loop.cwd()
          end,
        },
      }

      -- Setup telescope integration if telescope is available
      pcall(function()
        require("telescope").load_extension "harpoon"
      end)
    end,
  },
}
