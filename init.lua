vim.g.mapleader = " "

-- 1) Lazy.nvim bootstrap snippet

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2) Setup Lazy with your plugin specs
require("lazy").setup("plugins")

-- 3) Load your personal config
require("config")       -- if you have lua/config/init.lua

