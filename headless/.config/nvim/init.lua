-- Disable vim plugins defined in vimrc
vim.g.no_vim_plugins = 1

-- Source default vim config, with no vim plugins
vim.cmd("source $HOME/.vimrc")

-- Neovim specific config
require("user")
