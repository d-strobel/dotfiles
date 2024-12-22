return { 
	{
		"echasnovski/mini.nvim", 
		version = false,

		config = function() 
			require("mini.statusline").setup({ 
				use_icons = false 
			})
		end
	}

}
