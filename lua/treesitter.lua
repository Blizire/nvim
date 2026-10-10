local languages = {
  'python', 'rust', 'c', 'cpp', 'go',
  'typescript', 'tsx', 'javascript', 'lua', 'bash',
  'html', 'css', 'json', 'yaml', 'dockerfile',
}

-- Use syntax folds only; unsupported buffers have no automatic folds.
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = '0'
vim.opt.foldlevel = 99

local function enable(buf)
  local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
  local active = lang and pcall(vim.treesitter.start, buf, lang)
  local folds = active and vim.treesitter.query.get(lang, 'folds')
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.wo[win].foldmethod = 'expr'
    vim.wo[win].foldexpr = folds and 'v:lua.vim.treesitter.foldexpr()' or '0'
  end
end

-- Parsers already requested this session, so a failed install is not retried
-- on every buffer.
local requested = {}

-- Install a configured parser the first time a matching buffer is opened, then
-- enable Tree-sitter for every loaded buffer once it finishes.
local function auto_install(buf)
  local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
  if not lang or requested[lang] or not vim.list_contains(languages, lang) then
    return
  end
  requested[lang] = true

  local ts = require('nvim-treesitter')
  local ok, installed = pcall(ts.get_installed, 'parsers')
  if ok and vim.list_contains(installed, lang) then
    return
  end

  ts.install({ lang }):await(function()
    vim.schedule(function()
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(b) then
          enable(b)
        end
      end
    end)
  end)
end

vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter' }, {
  group = vim.api.nvim_create_augroup('UserTreesitter', { clear = true }),
  callback = function(args)
    enable(args.buf)
    auto_install(args.buf)
  end,
})

-- Parsers install automatically on first use; this installs them all up front
-- and also works in headless setup: wait before quitting.
vim.api.nvim_create_user_command('TSSetup', function()
  require('nvim-treesitter').install(languages):wait(300000)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      enable(buf)
    end
  end
end, { desc = 'Install configured Tree-sitter parsers (waits for completion)' })
