-- FUNCTIONS/VARIABLES

-- [ KEYMAPS ]

local set = function(lhs, rhs, opts, mode)
  mode = mode == nil and 'n' or mode
  if type(opts) == 'string' then
    opts = { desc = opts }
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function set_l(suffix, rhs, opts, mode)
  set('<Leader>' .. suffix, rhs, opts, mode)
end

-- [ AUTOCMDS ]

local augroup = function(name)
  vim.api.nvim_create_augroup(name, {})
end
local autocmd = vim.api.nvim_create_autocmd

-- [ PLUGINS ]

local gh = function(repo)
  vim.pack.add({ 'https://github.com/' .. repo })
end

local mini = function(mod)
  local sep = mod == 'git' and '-' or '.'
  gh('nvim-mini/mini' .. sep .. mod)
end

mini('misc')
local safely = require('mini.misc').safely
local now = function(fn)
  safely('now', fn)
end
local later = function(fn)
  safely('later', fn)
end
local args_load = vim.fn.argc(-1) > 0 and now or later

-- GLOBAL

-- leader
vim.g.mapleader = ' '

-- OPTIONS

-- line numbers
vim.o.number = true
vim.o.relativenumber = true

-- line wrap
vim.o.wrap = false

-- indents
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.tabstop = 2

-- case sensitivity
vim.o.ignorecase = true
vim.o.smartcase = true

-- completion
vim.o.completeopt = 'menuone,noselect'

-- cursor line
vim.o.cursorline = true

-- scroll off
vim.o.scrolloff = 5

-- whitespace
vim.o.listchars = 'nbsp:␣,tab:› '
vim.o.list = true

-- confirmation
vim.o.confirm = true

-- undo history
vim.o.undofile = true

-- splits
vim.o.splitbelow = true
vim.o.splitright = true

-- popupmenu
vim.o.pumborder = 'bold'
vim.o.pumheight = 20

-- signcolumn
vim.o.signcolumn = 'yes'

-- window border
vim.o.winborder = 'bold'

-- KEYMAPS

set('grD', vim.lsp.buf.declaration, 'vim.lsp.buf.declaration()')
set('grd', vim.lsp.buf.definition, 'vim.lsp.buf.definition()')
set('grf', vim.lsp.buf.format, 'vim.lsp.buf.format()', { 'n', 'x' })

set_l('Dl', vim.diagnostic.setloclist, 'Set diagnostics location list')
set_l('Dq', vim.diagnostic.setqflist, 'Set diagnostics quickfix list')

-- AUTOCMDS

autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup('hl-yank'),
  callback = function()
    vim.hl.hl_op()
  end,
})

-- DIAGNOSTICS

later(function()
  vim.diagnostic.config({
    severity_sort = true,
    virtual_text = {
      current_line = true,
    },
  })
end)

-- PLUGINS

-- [ MINI MODULES ]

now(function()
  mini('icons')
  require('mini.icons').setup()
end)

now(function()
  mini('notify')
  require('mini.notify').setup()
end)

now(function()
  mini('sessions')
  local sessions = require('mini.sessions')
  sessions.setup()

  set_l('sd', function()
    sessions.select('delete')
  end, 'Delete')
  set_l('sr', function()
    sessions.select('read')
  end, 'Read')
  set_l('sW', function()
    sessions.write(vim.fn.input('Session name: '))
  end, 'Write new')
  set_l('sw', sessions.write, 'Write')
end)

now(function()
  mini('starter')
  require('mini.starter').setup()
end)

now(function()
  mini('statusline')
  require('mini.statusline').setup()
end)

now(function()
  mini('tabline')
  require('mini.tabline').setup()
end)

args_load(function()
  mini('files')
  local files = require('mini.files')
  files.setup({
    mappings = {
      go_in = 'gf',
      go_in_plus = 'L',
      go_out = 'H',
    },
  })

  autocmd('User', {
    desc = 'Set MiniFiles bookmarks',
    group = augroup('MiniFiles bookmarks'),
    pattern = 'MiniFilesExplorerOpen',
    callback = function()
      local mark = function(id, path, desc)
        files.set_bookmark(id, path, { desc = desc })
      end
      mark('C', vim.fn.getcwd, 'Current Working Directory')
      mark('c', vim.fn.stdpath('config'), 'Config Directory')
      mark('p', '~/Projects', 'Projects Directory')
      mark('~', '~', 'Home Directory')
    end,
  })

  autocmd('User', {
    desc = 'Set MiniFiles keymaps',
    group = augroup('MiniFiles keymaps'),
    pattern = 'MiniFilesBufferCreate',
    callback = function(ev)
      local buf = ev.data.buf_id

      local handle_path = function(fn)
        local entry = files.get_fs_entry()
        if entry == nil then
          if vim.api.nvim_get_current_line() == '' then
            return vim.notify('FS entry is empty', vim.log.levels.ERROR)
          else
            return vim.notify('FS entry is not synchronized', vim.log.levels.ERROR)
          end
        end
        return fn(entry.path)
      end

      set('gx', function()
        handle_path(function(path)
          vim.ui.open(path)
        end)
      end, { buffer = buf, desc = 'Opens filepath under cursor with the system handler' })
      set('gy', function()
        handle_path(function(path)
          vim.fn.setreg(vim.v.register, path)
        end)
      end, { buffer = buf, desc = 'Yank filesystem entry to register' })
    end,
  })

  set_l('fO', files.open, 'Open')
  set_l('fo', function()
    files.open(vim.api.nvim_buf_get_name(0))
  end, 'Open to buffer')
end)

args_load(function()
  mini('misc')
  local misc = require('mini.misc')
  misc.setup()
  misc.setup_auto_root()
  misc.setup_restore_cursor()

  set_l('mr', misc.resize_window, 'Resize window')
  set_l('mz', misc.zoom, 'Zoom')
end)

args_load(function()
  mini('pick')
  require('mini.pick').setup()

  set_l('pb', '<Cmd>Pick buffers<CR>', 'Buffers')
  set_l('pf', '<Cmd>Pick files<CR>', 'Files')
  set_l('pg', '<Cmd>Pick grep_live<CR>', 'Grep live')
  set_l('ph', '<Cmd>Pick help<CR>', 'Help')
  set_l('pr', '<Cmd>Pick resume<CR>', 'Resume')
end)

later(function()
  mini('extra')
  require('mini.extra').setup()
end)

later(function()
  mini('ai')
  require('mini.ai').setup({
    custom_textobjects = {
      B = MiniExtra.gen_ai_spec.buffer(),
    },
  })
end)

later(function()
  mini('align')
  require('mini.align').setup()
end)

later(function()
  mini('animate')
  require('mini.animate').setup()
end)

later(function()
  mini('bracketed')
  require('mini.bracketed').setup()
end)

later(function()
  mini('clue')
  local clue = require('mini.clue')
  local clues = clue.gen_clues
  clue.setup({
    clues = {
      { mode = 'n', keys = '<Leader>D', desc = 'Diagnostics' },
      { mode = 'n', keys = '<Leader>d', desc = 'MiniDiagnostics' },
      { mode = 'n', keys = '<Leader>f', desc = 'MiniFiles' },
      { mode = 'n', keys = '<Leader>M', desc = 'MiniMap' },
      { mode = 'n', keys = '<Leader>m', desc = 'MiniMisc' },
      { mode = 'n', keys = '<Leader>p', desc = 'MiniPick' },
      { mode = 'n', keys = '<Leader>s', desc = 'MiniSessions' },
      { mode = 'n', keys = '<Leader>t', desc = 'MiniTrailspace' },
      clues.builtin_completion(),
      clues.g(),
      { mode = { 'n', 'x' }, keys = 'go', desc = '+Operators' },
      clues.marks(),
      clues.registers({ show_contents = true }),
      clues.square_brackets(),
      clues.windows({ submode_resize = true }),
      clues.z(),
    },
    triggers = {
      { mode = { 'n', 'x' }, keys = '<Leader>' },

      { mode = 'i', keys = '<C-x>' },

      { mode = { 'n', 'x' }, keys = 'g' },

      { mode = { 'n', 'x' }, keys = "'" },
      { mode = { 'n', 'x' }, keys = '`' },

      { mode = { 'n', 'x' }, keys = '"' },
      { mode = { 'i', 'c' }, keys = '<C-r>' },

      { mode = { 'n', 'x' }, keys = '[' },
      { mode = { 'n', 'x' }, keys = ']' },

      { mode = 'n', keys = '<C-w>' },

      { mode = { 'n', 'x' }, keys = 'z' },

      { mode = { 'n', 'x' }, keys = 's' },
    },
    window = {
      delay = 400,
      config = {
        width = 50,
      },
    },
  })
end)

later(function()
  mini('cmdline')
  require('mini.cmdline').setup()
end)

later(function()
  mini('cursorword')
  require('mini.cursorword').setup()
end)

later(function()
  mini('diff')
  local diff = require('mini.diff')
  diff.setup()

  set_l('d', diff.toggle_overlay, 'MiniDiff toggle overlay')
end)

later(function()
  mini('git')
  local git = require('mini.git')
  git.setup()

  set_l('g', git.show_at_cursor, 'MiniGit show at cursor', { 'n', 'x' })
end)

later(function()
  mini('hipatterns')
  local hipatterns = require('mini.hipatterns')
  local words = MiniExtra.gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      fixme = words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
      hack = words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
      todo = words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
      note = words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),

      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

later(function()
  mini('indentscope')
  require('mini.indentscope').setup({ symbol = '│' })
end)

later(function()
  mini('input')
  require('mini.input').setup()
end)

later(function()
  mini('jump')
  require('mini.jump').setup()
end)

later(function()
  mini('jump2d')
  require('mini.jump2d').setup()
end)

later(function()
  mini('map')
  local map = require('mini.map')
  local integration = map.gen_integration
  map.setup({
    symbols = { encode = map.gen_encode_symbols.dot('4x2') },
    integrations = {
      integration.builtin_search(),
      integration.diff(),
      integration.diagnostic(),
    },
  })

  for _, lhs in ipairs({ 'n', 'N', '*', '#' }) do
    local rhs = lhs .. 'zv<Cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>'
    set(lhs, rhs)
  end

  set_l('Mf', map.toggle_focus, 'Toggle focus')
  set_l('Mr', map.refresh, 'Refresh')
  set_l('Ms', map.toggle_side, 'Toggle side')
  set_l('Mt', map.toggle, 'Toggle')
end)

later(function()
  mini('move')
  require('mini.move').setup()
end)

later(function()
  mini('operators')
  require('mini.operators').setup({
    evaluate = { prefix = 'go=' },
    exchange = { prefix = 'gox' },
    multiply = { prefix = 'gom' },
    replace = { prefix = 'gor' },
    sort = { prefix = 'gos' },
  })
end)

later(function()
  mini('pairs')
  require('mini.pairs').setup()
end)

later(function()
  mini('splitjoin')
  require('mini.splitjoin').setup()
end)

later(function()
  mini('surround')
  require('mini.surround').setup()
end)

later(function()
  mini('trailspace')
  local trailspace = require('mini.trailspace')
  trailspace.setup()

  set_l('tT', trailspace.trim, 'Trim')
  set_l('tt', trailspace.trim_last_lines, 'Trim last lines')
end)

later(function()
  mini('visits')
  require('mini.visits').setup()
end)

-- [ MISC PLUGINS ]

now(function()
  gh('ellisonleao/gruvbox.nvim')
  require('gruvbox').setup({ contrast = 'hard' })

  vim.cmd.colorscheme('gruvbox')
end)

args_load(function()
  gh('neovim/nvim-lspconfig')

  vim.lsp.enable({ 'jedi_language_server', 'ruff' })
  autocmd('LspAttach', {
    desc = 'Enable LSP',
    group = augroup('lsp'),
    callback = function(ev)
      local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
      if client:supports_method('textDocument/completion') then
        local chars = {}
        for char = 32, 126 do
          table.insert(chars, string.char(char))
        end
        client.server_capabilities.completionProvider.triggerCharacters = chars

        vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      end
    end,
  })
end)
