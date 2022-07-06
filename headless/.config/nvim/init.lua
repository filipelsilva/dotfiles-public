-- Disable vim plugins defined in vimrc
vim.g.no_vim_plugins = 1

-- Default vim config
vim.cmd("source $HOME/.vimrc")

-- Modules
require("user.plugins")
require("user.colorscheme")
require("user.telescope")
require("user.comment")
require("user.lsp")
require("user.cmp")
require("user.treesitter")
