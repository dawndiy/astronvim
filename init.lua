return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin",     -- remote to use
    channel = "stable",    -- "stable" or "nightly"
    version = "latest",    -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly",    -- branch name (NIGHTLY ONLY)
    commit = nil,          -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil,     -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false,  -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false,     -- automatically quit the current session after a successful update
    remotes = {            -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },
  -- Set colorscheme to use
  -- colorscheme = "astrodark",
  -- colorscheme = "tokyonight",
  colorscheme = "catppuccin-mocha",
  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },
  lsp = {
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true,     -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
      "dartls",
      "sourcekit",
    },
    setup_handlers = {
      -- add custom handler
      dartls = function(_, opts) require("flutter-tools").setup { 
        lsp = opts,
        debugger = {
          enabled = true
        }
      } end,
      sourcekit = function(_, opts) require("lspconfig").sourcekit.setup { 
        -- lsp = opts,
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('UserLspConfig', {}),
          callback = function(ev)
            --enable omnifunc completion
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- buffer local mappings
            local opts = { buffer = ev.buf }
            -- go to definition
            vim.keymap.set('n','gd',vim.lsp.buf.definition,opts)
            --puts doc header info into a float page
            vim.keymap.set('n','K',vim.lsp.buf.hover,opts)

            -- workspace management. Necessary for multi-module projects
            vim.keymap.set('n','<space>wa',vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set('n','<space>wr',vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set('n','<space>wl',function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,opts)

            -- add LSP code actions
            vim.keymap.set({'n','v'},'<space>ca',vim.lsp.buf.code_action,opts)                

            -- find references of a type
            vim.keymap.set('n','gr',vim.lsp.buf.references,opts)
          end,
        })
      } end,
    },
    config = {
      dartls = {
        -- any changes you want to make to the LSP setup, for example
        color = {
          enabled = true,
        },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
        },
      },
      sourcekit = function()
        return {
          cmd = { "sourcekit-lsp" },
          -- cmd = { "xcrun --toolchain swift sourcekit-lsp" },
          filetypes = { "swift" },
          root_dir = require("lspconfig.util").root_pattern("Package.swift", ".git")
        }
      end,
    },
  },
  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },
  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}
