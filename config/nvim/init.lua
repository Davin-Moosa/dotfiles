-- GLOBALS

-- leader
vim.g.mapleader = ' '

-- OPTIONS

local opt = vim.o

-- line numbers
opt.number = true
opt.relativenumber = true

-- line wrap
opt.wrap = false

-- indents
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2

-- case sensitivity
opt.ignorecase = true
opt.smartcase = true

-- completion options
opt.completeopt = 'menuone,noselect,popup'

-- cursor line
opt.cursorline = true

-- scroll off
opt.scrolloff = 5

-- whitespace
opt.listchars = 'nbsp:␣,tab:› '
opt.list = true

-- confirmation
opt.confirm = true

-- history
opt.undofile = true
opt.history = 20

-- splits
opt.splitbelow = true
opt.splitright = true

-- title
opt.title = true
opt.titlestring = 'nvim %{expand("%:~:h")}'

-- popup menu
opt.pumborder = 'bold'
opt.pumheight = 20

-- update time
opt.updatetime = 2000

-- sign column
opt.signcolumn = 'yes'

-- window border
opt.winborder = 'bold'

-- KEYMAPS

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


set('grD', vim.lsp.buf.declaration, 'vim.lsp.buf.declaration()')
set('grd', vim.lsp.buf.definition, 'vim.lsp.buf.definition()')
set('grf', vim.lsp.buf.format, 'vim.lsp.buf.format()', { 'n', 'x' })

set_l('Dl', vim.diagnostic.setloclist, 'Set diagnostics location list')
set_l('Dq', vim.diagnostic.setqflist, 'Set diagnostics quickfix list')

-- AUTOCMDS

local augroup = function(name)
  vim.api.nvim_create_augroup(name, {})
end
local autocmd = vim.api.nvim_create_autocmd


autocmd({ 'TextYankPost', 'TextPutPost'}, {
  desc = 'Highlight when yanking (copying) text',
  group = augroup('hl'),
  callback = function()
    vim.hl.hl_op({ timeout = 300 })
  end,
})

-- DIAGNOSTICS

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = {
    current_line = true,
  },
})

-- PLUGINS

local gh = function(repos)
  vim.pack.add({ 'https://github.com/' .. repos })
end

gh('nvim-mini/mini.nvim')

local safely = require('mini.misc').safely
local now = function(fn)
  safely('now', fn)
end
local later = function(fn)
  safely('later', fn)
end
local args_load = vim.fn.argc(-1) > 0 and now or later


-- [ MINI MODULES ]

now(function()
  require('mini.icons').setup()
end)

now(function()
  require('mini.notify').setup()
end)

now(function()
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
  require('mini.starter').setup()
end)

now(function()
  require('mini.statusline').setup()
end)

now(function()
  require('mini.tabline').setup()
end)

args_load(function()
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
        if not entry then
          return vim.notify("Cannot yank 'FS entry': No such file or directory", vim.log.levels.ERROR)
        end
        return fn(entry.path)
      end

      set('gx', function()
        handle_path(function(path)
          vim.ui.open(path)
        end)
      end, { buffer = buf, desc = 'Open filepath under cursor with the system handler' })
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
  local misc = require('mini.misc')
  misc.setup()
  misc.setup_auto_root()
  misc.setup_restore_cursor()
  misc.setup_termbg_sync()

  set_l('mr', misc.resize_window, 'Resize window')
  set_l('mz', misc.zoom, 'Zoom')
end)

args_load(function()
  require('mini.pick').setup()

  set_l('pb', '<Cmd>Pick buffers<CR>', 'Buffers')
  set_l('pf', '<Cmd>Pick files<CR>', 'Files')
  set_l('pg', '<Cmd>Pick grep_live<CR>', 'Grep live')
  set_l('pH', '<Cmd>Pick help<CR>', 'Help')
  set_l('pr', '<Cmd>Pick resume<CR>', 'Resume')

  -- SETUP EXTRA PICKER
  set_l('pB', '<Cmd>Pick buf_lines<CR>', 'Buffer Lines')
  set_l('pd', '<Cmd>Pick diagnostic<CR>', 'Diagnostics')
  set_l('pe', '<Cmd>Pick explorer<CR>', 'Explorer')
  set_l('pGb', '<Cmd>Pick git_branches<CR>', 'Branches')
  set_l('pGc', '<Cmd>Pick git_commits<CR>', 'Commits')
  set_l('pGft', '<Cmd>Pick git_files scope="tracked"<CR>', 'Tracked')
  set_l('pGfm', '<Cmd>Pick git_files scope="modified"<CR>', 'Modified')
  set_l('pGfu', '<Cmd>Pick git_files scope="untracked"<CR>', 'Untracked')
  set_l('pGfi', '<Cmd>Pick git_files scope="ignored"<CR>', 'Ignored')
  set_l('pGfd', '<Cmd>Pick git_files scope="deleted"<CR>', 'Deleted')
  set_l('pGhu', '<Cmd>Pick git_hunks scope="unstaged"<CR>', 'Unstaged')
  set_l('pGhs', '<Cmd>Pick git_hunks scope="staged"<CR>', 'Staged')
  set_l('ph', '<Cmd>Pick hipatterns<CR>', 'Highlight Patterns')
  set_l('pLc', '<Cmd>Pick list scope="change"<CR>', 'Change')
  set_l('pLj', '<Cmd>Pick list scope="jump"<CR>', 'Jump')
  set_l('pLl', '<Cmd>Pick list scope="location"<CR>', 'Location')
  set_l('pLq', '<Cmd>Pick list scope="quickfix"<CR>', 'QuickFix')
  set_l('pld', '<Cmd>Pick lsp scope="document_symbol"', 'Document symbols')
  set_l('plw', '<Cmd>Pick lsp scope="workspace_symbol_live"', 'Workspace symbols live')
  set_l('pm', '<Cmd>Pick marks<CR>', 'Marks')
  set_l('po', '<Cmd>Pick oldfiles<CR>', 'Old Files')
  set_l('pR', '<Cmd>Pick registers<CR>', 'Registers')
end)

later(function()
  require('mini.extra').setup()
end)

later(function()
  local spec = MiniExtra.gen_ai_spec
  require('mini.ai').setup({
    custom_textobjects = {
      B = spec.buffer(),
      D = spec.diagnostic(),
      I = spec.indent(),
      L = spec.line(),
      N = spec.number(),
    },
  })
end)

later(function()
  require('mini.align').setup()
end)

later(function()
  require('mini.animate').setup()
end)

later(function()
  require('mini.bracketed').setup()
end)

later(function()
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
      { mode = 'n', keys = '<Leader>pG', desc = 'Git' },
      { mode = 'n', keys = '<Leader>pGf', desc = 'Files' },
      { mode = 'n', keys = '<Leader>pGh', desc = 'Hunks' },
      { mode = 'n', keys = '<Leader>pL', desc = 'List' },
      { mode = 'n', keys = '<Leader>pl', desc = 'LSP' },
      { mode = 'n', keys = '<Leader>s', desc = 'MiniSessions' },
      { mode = 'n', keys = '<Leader>t', desc = 'MiniTrailspace' },
      { mode = 'n', keys = '<Leader>v', desc = 'MiniVisits' },
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
  require('mini.cmdline').setup()
end)

later(function()
  require('mini.cursorword').setup()
end)

later(function()
  local diff = require('mini.diff')
  diff.setup()

  set_l('d', diff.toggle_overlay, 'MiniDiff toggle overlay')
end)

later(function()
  local git = require('mini.git')
  git.setup()

  set_l('g', git.show_at_cursor, 'MiniGit show at cursor', { 'n', 'x' })
end)

later(function()
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
  require('mini.indentscope').setup({ symbol = '│' })
end)

later(function()
  require('mini.input').setup()
end)

later(function()
  require('mini.jump').setup()
end)

later(function()
  require('mini.jump2d').setup()
end)

later(function()
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
  require('mini.move').setup()
end)

later(function()
  require('mini.operators').setup({
    evaluate = { prefix = 'go=' },
    exchange = { prefix = 'gox' },
    multiply = { prefix = 'gom' },
    replace = { prefix = 'gor' },
    sort = { prefix = 'gos' },
  })
end)

later(function()
  require('mini.pairs').setup()
end)

later(function()
  require('mini.splitjoin').setup()
end)

later(function()
  require('mini.surround').setup()
end)

later(function()
  local trailspace = require('mini.trailspace')
  trailspace.setup()

  set_l('tT', trailspace.trim, 'Trim')
  set_l('tt', trailspace.trim_last_lines, 'Trim last lines')
end)

later(function()
  local visits = require('mini.visits')
  require('mini.visits').setup()

  local frecency = { sort = visits.gen_sort.default({ recency_weight = 0.5 }) }

  set_l('va', visits.add_label, 'Add label')
  set_l('vr', visits.remove_label, 'Remove label')
  set_l('vS', function()
    visits.select_label('', nil, frecency)
  end, 'Select label')
  set_l('vs', function()
    visits.select_path(nil, frecency)
  end, 'Select path')
end)

-- [ MISC PLUGINS ]

now(function()
  gh('folke/tokyonight.nvim')

  vim.cmd.colorscheme('tokyonight-night')
end)

args_load(function()
  gh('neovim/nvim-lspconfig')

  vim.lsp.enable({ 'gdscript', 'lua_ls', 'nixd', 'pyrefly' })
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

args_load(function()
  autocmd('PackChanged', {
    desc = 'Update Nvim Treesitter',
    group = augroup('nvim-treesitter'),
    callback = function(ev)
      if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
        if not ev.data.active then
          vim.cmd.packadd('nvim-treesitter')
        end
        vim.cmd.TSUpdate()
      end
    end,
  })
  gh('nvim-treesitter/nvim-treesitter')

  local langs = { 'bash', 'css', 'json', 'lua', 'nix', 'markdown', 'python' }
  require('nvim-treesitter').install(langs)

  vim.cmd.packadd('nvim-treesitter')
  local ft = { }
  for _, lang in ipairs(langs) do
    vim.list_extend(ft, vim.treesitter.language.get_filetypes(lang))
  end

  autocmd('FileType', {
    desc = 'Enable Nvim Treesitter',
    group = augroup('nvim-treesitter'),
    pattern = ft,
    callback = function()
      -- syntax
      vim.treesitter.start()

      -- folds
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo.foldmethod = 'expr'
      vim.wo.foldlevel = 99

      -- indents
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
end)

safely('filetype:markdown', function()
  gh('MeanderingProgrammer/render-markdown.nvim')
end)
