-- Disable vim plugins defined in vimrc
vim.g.no_vim_plugins = 1

-- Default vim config
vim.cmd("source $HOME/.vimrc")

-- Plugins {{{
local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
	vim.api.nvim_create_autocmd("VimEnter", { command = "silent! source $MYVIMRC | PackerComplete" })
end

local packer = require("packer")

-- Packer settings {{{
packer.init({
	display = {
		working_sym = "[WORKING]",
		error_sym = "[ERROR]",
		done_sym = "[DONE]",
		removed_sym = "[REMOVED]",
		moved_sym = "[MOVED]",
		header_sym = "",
	}
})
-- }}}

packer.startup(function(use)
	use "wbthomason/packer.nvim"

	-- Indentation detector
	use "tpope/vim-sleuth"

	-- Surround stuff
	use "tpope/vim-surround"

	-- Comment stuff
	use "numToStr/Comment.nvim"

	-- Colorscheme
	use "gruvbox-community/gruvbox"

	-- Fzf
	use "junegunn/fzf.vim"

	-- Telescope
	use {
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim"
		}
	}

	-- Lsp
	use {
		"neovim/nvim-lspconfig",
		requires = {
			-- Auto installer
			"williamboman/nvim-lsp-installer"
		}
	}

	-- Completion
	use {
		"hrsh7th/nvim-cmp",
		requires = {
			-- Snippets
			"L3MON4D3/LuaSnip",
			-- Completion sources
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline"
		}
	}

	-- Treesitter
	use {
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		requires = {
			"nvim-treesitter/playground"
		}
	}

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
-- }}}

-- Colorscheme
vim.o.termguicolors = true
vim.g.gruvbox_italic = 1
vim.g.gruvbox_italicize_strings = 1
vim.g.gruvbox_invert_selection = 0
vim.g.gruvbox_invert_signs = 1
vim.g.gruvbox_contrast_dark = "hard"
vim.cmd("colorscheme gruvbox")

-- Telescope {{{
local telescope_keybind_options = { noremap = true, silent = true }
_G.TELESCOPE_FUZZY_FILE = function()
	if vim.fn.len(vim.fn.system("git rev-parse")) == 0 then
		require("telescope.builtin").git_files({ hidden = true })
	else
		require("telescope.builtin").find_files({ hidden = true })
	end
end

vim.keymap.set("n", "<Leader>a", [[<Cmd>Telescope<CR>]], telescope_keybind_options)
vim.keymap.set("n", "<Leader>f", [[<Cmd>lua TELESCOPE_FUZZY_FILE()<CR>]], telescope_keybind_options)
vim.keymap.set("n", "<Leader><Leader>f", [[<Cmd>lua require("telescope.builtin").find_files({ cwd = "$HOME", hidden = true })<CR>]], telescope_keybind_options)
vim.keymap.set("n", "<Leader>F", [[<Cmd>lua require("telescope.builtin").find_files({ cwd = require("telescope.utils").buffer_dir(), hidden = true })<CR>]], telescope_keybind_options)
vim.keymap.set("n", "<Leader>r", [[<Cmd>lua require("telescope.builtin").live_grep()<CR>]], telescope_keybind_options)
vim.keymap.set("n", "<Leader>j", [[<Cmd>lua require("telescope.builtin").buffers()<CR>]], telescope_keybind_options)

local telescope = require("telescope")
local actions = require("telescope.actions")
telescope.setup({
	defaults = {
		sorting_strategy = "ascending",
		layout_strategy = "flex",
		layout_config = {
			prompt_position = "top",
			width = 0.90,
			height = 0.60,
		},
		path_display = {
			"truncate",
		},
		mappings = {
			i = {
				["<c-s>"] = actions.select_horizontal,
				["<c-x>"] = false,
				["<c-a>"] = actions.select_all,
			},
			n = {
				["<c-s>"] = actions.select_horizontal,
				["<c-x>"] = false,
				["<c-a>"] = actions.select_all,
			},
		},
	},
})
-- }}}

-- Comment.nvim {{{
local comment = require("Comment")
comment.setup({
	padding = true,
	sticky = true,
	ignore = nil,
	toggler = {
		line = "gcc",
		block = "gbb",
	},
	opleader = {
		line = "gc",
		block = "gb",
	},
	extra = {
		above = "gcO",
		below = "gco",
		eol = "gcA",
	},
	mappings = {
		basic = true,
		extra = true,
		extended = true,
	},
	pre_hook = nil,
	post_hook = nil,
})
-- }}}

-- LSP {{{
local custom_on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gd", [[<Cmd>lua vim.lsp.buf.definition()<CR>]], bufopts)
	vim.keymap.set("n", "<Leader><Leader>a", [[<Cmd>lua vim.lsp.buf.code_action()<CR>]], bufopts)
	vim.keymap.set("n", "<Leader>k", [[<Cmd>lua vim.lsp.buf.hover()<CR>]], bufopts)
	vim.keymap.set("n", "<Leader>s", [[<Cmd>lua vim.lsp.buf.rename()<CR>]], bufopts)
	vim.keymap.set("n", "[e", [[<Cmd>lua vim.diagnostic.goto_prev()<CR>]], bufopts)
	vim.keymap.set("n", "]e", [[<Cmd>lua vim.diagnostic.goto_next()<CR>]], bufopts)
end

local new_capabilities = vim.lsp.protocol.make_client_capabilities()
new_capabilities = require("cmp_nvim_lsp").update_capabilities(new_capabilities)

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.setup({
	ui = {
		icons = {
			server_installed = "[INSTALLED]",
			server_pending = "[PENDING]",
			server_uninstalled = "[UNINSTALLED]",
		},
	},
})

local lspconfig = require("lspconfig")
local servers = require("nvim-lsp-installer.servers").get_installed_servers()
for _, server in pairs(servers) do
	local settings = nil
	if server.name == "sumneko_lua" then
		settings = { Lua = { diagnostics = { globals = { "vim" } } } }
	end
	lspconfig[server.name].setup({
		on_attach = custom_on_attach,
		capabilities = new_capabilities,
		settings = settings,
	})
end
-- }}}

-- Nvim-cmp {{{
local cmp = require("cmp")
local ls = require("luasnip")

-- Helper functions {{{
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Next completion or move in snippet
local complete_or_snippet_next = function(fallback)
	if cmp.visible() then
		cmp.select_next_item()
	elseif ls.expand_or_jumpable() then
		ls.expand_or_jump()
	elseif has_words_before() then
		cmp.complete()
	else
		fallback()
	end
end

-- Previous completion or move in snippet
local complete_or_snippet_prev = function(fallback)
	if cmp.visible() then
		cmp.select_prev_item()
	elseif ls.jumpable(-1) then
		ls.jump(-1)
	else
		fallback()
	end
end
-- }}}

cmp.setup({
	snippet = {
		expand = function(args)
			ls.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-y>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
		["<C-n>"] = cmp.mapping(complete_or_snippet_next, { "i", "s" }),
		["<C-p>"] = cmp.mapping(complete_or_snippet_prev, { "i", "s" }),
		["<Tab>"] = cmp.mapping(complete_or_snippet_next, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(complete_or_snippet_prev, { "i", "s" }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	}),
})
-- }}}

-- Treesitter {{{
local treesitter = require("nvim-treesitter.configs")
treesitter.setup({
	ensure_installed = {
		"bash",
		"c",
		"cpp",
		"dockerfile",
		"go",
		"go",
		"html",
		"java",
		"javascript",
		"json",
		"json",
		"lua",
		"make",
		"markdown",
		"nix",
		"python",
		"rust",
		"toml",
		"typescript",
		"vim"
	},
	sync_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	playground = {
		enable = true,
	},
})
-- }}}
