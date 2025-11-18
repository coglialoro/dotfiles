return {
	"marko-cerovac/material.nvim",
	config = function()
		vim.cmd("colorscheme material")
		vim.g.material_style = "darker"

		require("material").setup({
			lualine_style = "default",
		})

		vim.keymap.set("n", "<leader>th", function()
			require("material.functions").find_style()
		end, { desc = "Change theme" })
		-- Transparent background
		vim.cmd([[
      highlight Normal guibg=none
      highlight NonText guibg=none
      highlight Normal ctermbg=none
      highlight NonText ctermbg=none
    ]])
	end,
	priority = 100,
}
