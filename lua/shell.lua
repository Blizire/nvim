local is_windows = vim.fn.has('win32') == 1

if is_windows then
  -- Prefer PowerShell 7, with built-in Windows PowerShell as the fallback.
  local pwsh = vim.fn.exepath('pwsh')
  local powershell = pwsh ~= '' and pwsh or vim.fn.exepath('powershell')
  if powershell == '' then
    vim.notify('PowerShell was not found on PATH; keeping the existing shell.', vim.log.levels.WARN)
    return
  end

  vim.opt.shell = powershell
  vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
    .. '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();'
    .. "$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
  if pwsh ~= '' then
    vim.opt.shellcmdflag:append("if ($PSStyle) { $PSStyle.OutputRendering = 'PlainText' };")
    vim.env.__SuppressAnsiEscapeSequences = '1'
  end
  vim.opt.shellquote = ''
  vim.opt.shellxquote = ''
  vim.opt.shellpipe = '> %s 2>&1'
  vim.opt.shellredir = '> %s 2>&1'
  vim.opt.shelltemp = false
else
  -- Includes macOS, Linux, and Linux running inside WSL.
  local bash = vim.fn.exepath('bash')
  if bash == '' then
    vim.notify('Bash was not found on PATH; keeping the existing shell.', vim.log.levels.WARN)
    return
  end

  vim.opt.shell = bash
  vim.opt.shellcmdflag = '-c'
  vim.opt.shellquote = ''
  vim.opt.shellxquote = ''
  vim.opt.shellpipe = '2>&1| tee'
  vim.opt.shellredir = '>%s 2>&1'
end
