# Declarative Neovim configuration
{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      # Plugin manager
      lazy-nvim

      # UI and themes
      alpha-nvim
      oxocarbon-nvim
      toggleterm-nvim
      neo-tree-nvim
      plenary-nvim
      nvim-web-devicons
      nui-nvim

      # AI completion
      copilot-lua
      avante-nvim

      # Development
      nvim-treesitter
      zen-mode-nvim
      dressing-nvim
      mini-pick
      telescope-nvim
      nvim-cmp
      fzf-lua
      img-clip-nvim
      render-markdown-nvim
    ];

    extraPackages = with pkgs; [
      # Dependencies for plugins
      git
      fzf
      ripgrep
      nodejs # For Copilot
      tree-sitter
    ];

    extraLuaConfig = ''
      -- Bootstrap lazy.nvim
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
          "git",
          "clone",
          "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable",
          lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)

      -- Leader key setup
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      -- Basic settings
      vim.opt.number = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.wrap = true
      vim.opt.linebreak = true
      vim.opt.timeoutlen = 300
      vim.opt.laststatus = 3
      vim.opt.shortmess:append('I')

      -- Plugin configurations
      require("lazy").setup({
        -- Alpha-nvim (Dashboard)
        {
          'goolord/alpha-nvim',
          event = 'VimEnter',
          config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            dashboard.section.header.val = {
              "██╗   ██╗ ██████╗ ██╗██████╗ ",
              "██║   ██║██╔═══██╗██║██╔══██╗",
              "██║   ██║██║   ██║██║██║  ██║",
              "╚██████╔╝╚██████╔╝██║██████╔╝",
              " ╚═════╝  ╚═════╝ ╚═╝╚═════╝ ",
              "",
              "the infinite abyss awaits...",
              "                                ",
              " 'Live, Love, Rock N' Roll'       ",
              "                   - Nina Iseri "
            }

            dashboard.section.buttons.val = {}
            dashboard.section.footer.val = {}

            dashboard.opts.layout = {
              { type = "padding", val = 8 },
              { type = "text", val = dashboard.section.header.val, opts = { position = "center" } },
              { type = "padding", val = 8 },
            }

            alpha.setup(dashboard.opts)
          end
        },

        -- Toggleterm
        {
          'akinsho/toggleterm.nvim',
          version = '*',
          config = function()
            require('toggleterm').setup({
              size = 30,
              open_mapping = [[<c-Space>]],
              direction = 'float',
              float_opts = {
                winblend = 0,
              }
            })
          end
        },

        -- Theme configuration
        {
          "nyoom-engineering/oxocarbon.nvim",
          lazy = false,
          priority = 1000,
          config = function()
            vim.opt.background = "dark"
            vim.cmd("colorscheme oxocarbon")
            vim.cmd("hi Normal guibg=#000000")

            -- Vibrancy Boost
            vim.api.nvim_set_hl(0, "Function", { fg = "#FF8800" })
            vim.api.nvim_set_hl(0, "Keyword",  { fg = "#A0FF00", bold = true })
            vim.api.nvim_set_hl(0, "Constant", { fg = "#FF66CC" })
            vim.api.nvim_set_hl(0, "String",   { fg = "#77DDEE" })
            vim.api.nvim_set_hl(0, "Type",     { fg = "#A599E9" })
            vim.api.nvim_set_hl(0, "Comment",  { fg = "#5c6370", italic = true })
          end,
        },

        -- Neo-tree
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
                  ["<C-CR>"] = "open_vsplit",
                },
              },
            })
          end,
        },

        -- Zen mode
        {
          'folke/zen-mode.nvim',
          config = function()
            require('zen-mode').setup({
              window = {
                width = 1,
                height = 1,
              }
            })
            vim.keymap.set('n', '<leader>f', ':ZenMode<CR>', { desc = 'Zen Mode' })
          end
        },

        -- Avante (AI completion)
        {
          "yetone/avante.nvim",
          event = "VeryLazy",
          version = false,
          opts = {
            provider = "copilot",
            copilot = {
              model = "gpt-4",
              timeout = 30000,
              temperature = 0,
              max_completion_tokens = 8192,
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
            "zbirenbaum/copilot.lua",
          },
        },
      })

      -- Directional resizing functions
      local function resize(direction)
        local amount = 3
        local cmd = direction == 'left'  and 'vertical resize -'..amount ..'<cr>' or
                   direction == 'right' and 'vertical resize +'..amount ..'<cr>' or
                   direction == 'down'  and 'resize +'..amount ..'<cr>' or
                   direction == 'up'    and 'resize -'..amount ..'<cr>'
        vim.cmd('silent! '..cmd)
      end

      -- Resize keymaps
      vim.keymap.set('n', '<leader>h', function() resize('left') end, { desc = '← Move divider left' })
      vim.keymap.set('n', '<leader>l', function() resize('right') end, { desc = '→ Move divider right' })
      vim.keymap.set('n', '<leader>j', function() resize('down') end, { desc = '↓ Move divider down' })
      vim.keymap.set('n', '<leader>k', function() resize('up') end, { desc = '↑ Move divider up' })

      -- Terminal mode support
      vim.keymap.set('t', '<leader>h', [[<C-\><C-n><leader>h]], { desc = '← Move left' })
      vim.keymap.set('t', '<leader>l', [[<C-\><C-n><leader>l]], { desc = '→ Move right' })
    '';
  };
}