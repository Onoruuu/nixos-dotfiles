-- Bootstrap Lazy.nvim (auto-install if missing)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Configure plugins
require("lazy").setup({


-- enter the void
{
  'goolord/alpha-nvim',
  event = 'VimEnter',
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- CORRECTED "VOID" ASCII art
    dashboard.section.header.val = {
      "██╗   ██╗ ██████╗ ██╗██████╗ ",
      "██║   ██║██╔═══██╗██║██╔══██╗",
      "██║   ██║██║   ██║██║██║  ██║",
      "╚██████╔╝╚██████╔╝██║██████╔╝",
      " ╚═════╝  ╚═════╝ ╚═╝╚═════╝ ",
      "",
      "the infinite abyss awaits...",
			"                                ";
			" 'Live, Love, Rock N' Roll'       ";
			"                   - Nina Iseri "

    }

    -- Remove ALL dashboard elements
    dashboard.section.buttons.val = {}
    dashboard.section.footer.val = {}

    -- Pure black background
--   vim.api.nvim_set_hl(0, 'Normal', { bg = '#000000' })
--   vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#000000' })

    -- Center alignment
    dashboard.opts.layout = {
      { type = "padding", val = 8 },  -- Top padding
      { type = "text", val = dashboard.section.header.val, opts = { position = "center" } },
      { type = "padding", val = 8 },  -- Bottom padding
    }

    alpha.setup(dashboard.opts)
  end
};

-- Toggle Terminal
{
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup({
      size = 30,
      open_mapping = [[<c-Space>]],  -- Ctrl+\ to toggle
      direction = 'float',       -- Or 'horizontal'/'vertical'
      float_opts = {
        winblend = 0,           -- Semi-transparent
      }
    })
  end
};


{
  "nyoom-engineering/oxocarbon.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.opt.background = "dark"
    vim.cmd("colorscheme oxocarbon")

    -- Force true black background
    vim.cmd("hi Normal guibg=#000000")

    -- 💥 Vibrancy Boost: Override specific highlight groups
    vim.api.nvim_set_hl(0, "Function", { fg = "#FF8800" })      -- Vibrant orange
    vim.api.nvim_set_hl(0, "Keyword",  { fg = "#A0FF00", bold = true }) -- Lime green
    vim.api.nvim_set_hl(0, "Constant", { fg = "#FF66CC" })      -- Pink
    vim.api.nvim_set_hl(0, "String",   { fg = "#77DDEE" })      -- Cyan
    vim.api.nvim_set_hl(0, "Type",     { fg = "#A599E9" })      -- Keep Oxo purple
    vim.api.nvim_set_hl(0, "Comment",  { fg = "#5c6370", italic = true }) -- Dim grey
  end,
};



-- Neo-tree (file explorer)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle NeoTree" },
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        window = {
          mappings = {
						["<C-CR>"] = "open_vsplit",  -- Ctrl+Enter opens in vertical split
          },
        },
      })
    end,
  },


-- zen mode
{
  'folke/zen-mode.nvim',
  config = function()
    require('zen-mode').setup({
      window = {
        width = 1, -- 95% of screen width
        height = 1,    -- Full height
      }
    })
    vim.keymap.set('n', '<leader>f', ':ZenMode<CR>', { desc = 'Zen Mode' })
  end
};

-- Avante (AI code completion)
{
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  opts = {
    -- change provider to copilot
    provider = "copilot",
    copilot = {
      model = "gpt-4", -- this is just symbolic; Copilot manages model behind the scenes
      timeout = 30000, -- still useful if Avante uses timeouts
      temperature = 0,
      max_completion_tokens = 8192,
      -- you can add other copilot-specific settings here if needed
    },
  },
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "echasnovski/mini.pick",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
    "nvim-tree/nvim-web-devicons",
    "zbirenbaum/copilot.lua", -- important dependency for copilot provider
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false, 
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
       file_types = { "markdown", "Avante" },
     },
     ft = { "markdown", "Avante" },
   },
  },
}

})
-- Basic settings (optional but recommended)
vim.opt.number = true       -- Line numbers
vim.opt.tabstop = 2         -- 2 spaces per tab
vim.opt.shiftwidth = 2      -- Auto-indent uses 2 spaces

vim.opt.wrap = true              -- Enable line wrapping
vim.opt.linebreak = true         -- Break at word boundaries



-- DIRECTIONAL RESIZING ###################


-- Guaranteed-working directional resizing
local function resize(direction)
  local amount = 3  -- Change this number to adjust resize step size
  local cmd = direction == 'left'  and 'vertical resize -'..amount ..'<cr>' or
              direction == 'right' and 'vertical resize +'..amount ..'<cr>' or
              direction == 'down'  and 'resize +'..amount ..'<cr>' or
              direction == 'up'    and 'resize -'..amount ..'<cr>'
  
  -- Execute silently without echo
  vim.cmd('silent! '..cmd)
end

-- Keymaps that work exactly as expected
vim.keymap.set('n', '<leader>h', function() resize('left') end, { desc = '← Move divider left' })
vim.keymap.set('n', '<leader>l', function() resize('right') end, { desc = '→ Move divider right' })
vim.keymap.set('n', '<leader>j', function() resize('down') end, { desc = '↓ Move divider down' })
vim.keymap.set('n', '<leader>k', function() resize('up') end, { desc = '↑ Move divider up' })

-- Optional: Terminal mode support
vim.keymap.set('t', '<leader>h', [[<C-\><C-n><leader>h]], { desc = '← Move left' })
vim.keymap.set('t', '<leader>l', [[<C-\><C-n><leader>l]], { desc = '→ Move right' })



-- Disable default intro message
vim.opt.shortmess:append('I')

-- views can only be fully collapsed with the global statusline (important for avante)
vim.opt.laststatus = 3

-- allows me to press space in terminal faster
vim.opt.timeoutlen = 300  -- Normal mapping timeout

