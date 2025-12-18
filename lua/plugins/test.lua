return {
  { 'nvim-neotest/neotest-plenary' },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-neotest/neotest-jest',
      'marilari88/neotest-vitest',
      'V13Axel/neotest-pest',
      'antoinemadec/FixCursorHold.nvim',
      {
        'nvim-treesitter/nvim-treesitter', -- Optional, but recommended
        branch = 'main',
        build = function()
          vim.cmd [[:TSUpdate go]]
        end,
      },
      {
        'fredrikaverpil/neotest-golang',
        version = '*', -- Optional, but recommended
        build = function()
          vim.system({ 'go', 'install', 'gotest.tools/gotestsum@latest' }):wait() -- Optional, but recommended
        end,
      },
    },
    opts = {
      adapters = {
        ['neotest-golang'] = {
          go_test_args = {
            '-v',
            '-race',
            '-count=1',
          },
        },
      },
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          require('trouble').open { mode = 'quickfix', focus = false }
        end,
      },
    },
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace 'neotest'
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message
              :gsub('\n', ' ')
              :gsub('\t', ' ')
              :gsub('%s+', ' ')
              :gsub('^%s+', '')
            return message
          end,
        },
      }, neotest_ns)

      opts.consumers = opts.consumers or {}
      -- Refresh and auto close trouble after running tests
      ---@type neotest.Consumer
      opts.consumers.trouble = function(client)
        client.listeners.results = function(adapter_id, results, partial)
          if partial then
            return
          end
          local tree =
            assert(client:get_position(nil, { adapter = adapter_id }))

          local failed = 0
          for pos_id, result in pairs(results) do
            if result.status == 'failed' and tree:get_key(pos_id) then
              failed = failed + 1
            end
          end
          vim.schedule(function()
            local trouble = require 'trouble'
            if trouble.is_open() then
              trouble.refresh()
              if failed == 0 then
                trouble.close()
              end
            end
          end)
        end
        return {}
      end

      opts.consumers.overseer = require 'neotest.consumers.overseer'

      if opts.adapters then
        -- Helper function to check if file exists
        local function file_exists(name)
          local f = io.open(name, 'r')
          if f ~= nil then
            io.close(f)
            return true
          end
          return false
        end

        local cwd = vim.fn.getcwd()
        local adapters = {}

        -- Go projects
        if file_exists(cwd .. '/go.mod') then
          table.insert(adapters, require('neotest-golang')(opts.adapters['neotest-golang'] or {}))
        end

        -- JavaScript/TypeScript projects
        if file_exists(cwd .. '/package.json') then
          -- Check for Vitest config first
          if file_exists(cwd .. '/vitest.config.js') or file_exists(cwd .. '/vitest.config.ts') then
            table.insert(adapters, require 'neotest-vitest')
          -- Then check for Jest
          elseif file_exists(cwd .. '/jest.config.js') or file_exists(cwd .. '/jest.config.ts') then
            table.insert(
              adapters,
              require 'neotest-jest' {
                jestCommand = 'npm test --',
                jestConfigFile = 'jest.config.js',
                env = { CI = true },
                cwd = function()
                  return vim.fn.getcwd()
                end,
              }
            )
          end
        end

        -- PHP projects
        if file_exists(cwd .. '/composer.json') then
          table.insert(adapters, require 'neotest-pest')
        end

        -- C# projects (check only root directory)
        local sln_files = vim.fn.glob(cwd .. '/*.sln', false, true)
        local csproj_files = vim.fn.glob(cwd .. '/*.csproj', false, true)
        -- Filter out any files found in node_modules
        local has_sln = #sln_files > 0
          and not sln_files[1]:match '/node_modules/'
        local has_csproj = #csproj_files > 0
          and not csproj_files[1]:match '/node_modules/'
        if has_sln or has_csproj then
          table.insert(adapters, require 'neotest-vstest')
        end

        -- Neovim plugin development (always available for config repo)
        table.insert(adapters, require 'neotest-plenary')


        opts.adapters = adapters
      end

      require('neotest').setup(opts)
    end,
    -- stylua: ignore
    keys = {
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File (Neotest)" },
      { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files (Neotest)" },
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest (Neotest)" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last (Neotest)" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary (Neotest)" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output (Neotest)" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel (Neotest)" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop (Neotest)" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch (Neotest)" },
    },
  },
  {
    'mfussenegger/nvim-dap',
    optional = true,
    -- stylua: ignore
    keys = {
      { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest (Neotest)" },
    },
  },
}
