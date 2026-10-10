-- Use the terminal clipboard across local, SSH, and Zellij sessions.
-- Keep p/P and deletes on Neovim's internal registers, without clipboard reads.
vim.opt.clipboard = ''
vim.g.clipboard = 'osc52'

local copy = require('vim.ui.clipboard.osc52').copy('+')
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('UserOsc52Yank', { clear = true }),
  desc = 'Copy ordinary yanks to the terminal clipboard through OSC 52',
  callback = function()
    local event = vim.v.event
    if event.operator == 'y' and event.regname == '' then
      copy(event.regcontents, event.regtype)
    end
  end,
})
