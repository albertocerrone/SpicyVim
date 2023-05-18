return {
  {
    "nvim-neotest/neotest",
    opts = function()
      return {
        adapters = {
          require("neotest-python")({
            dap = {
              justMyCode = false,
              -- console = "integratedTerminal",
            },
            pytest_discovery = true,
            args = { "--log-level", "DEBUG", "--quiet" },
            runner = "pytest",
          })
        }}
    end,
    keys = function ()
      -- local lib = require("neotest.lib")
      local get_env = function()
        local env = {}
        local file = ".env"
        -- if not lib.files.exists(file) then
        --   return {}
        -- end

        for _, line in ipairs(vim.fn.readfile(file)) do
          for name, value in string.gmatch(line, "(%S+)=['\"]?(.*)['\"]?") do
            local str_end = string.sub(value, -1, -1)
            if str_end == "'" or str_end == '"' then
              value = string.sub(value, 1, -2)
            end

            env[name] = value
          end
        end
        return env
      end
      
      return {
        {
          "<leader>dm",
          function()
            require("neotest").run.run({env = get_env()})
          end,
          desc = "Test: Run Method"
        },
        {
          "<leader>dM",
          function()
            require("neotest").run.run({strategy = 'dap', env = get_env()})
          end,
          desc = "Test: Debug Test Method"
        },
        {
          "<leader>df",
          function()
            require("neotest").run.run({vim.fn.expand('%'), env = get_env()})
          end,
          desc = "Test: Run File"
        },
        {
          "<leader>dF",
          function()
            require("neotest").run.run({vim.fn.expand('%'),strategy = 'dap', env = get_env()})
          end,
          desc = "Test: Debug Test File"
        },
        {
          "<leader>dS",
          function()
            require("neotest").summary.toggle()
          end,
          desc = "Test: Summary"
        },
      }
    end,
    config = function(opts)
      local neotest = require("neotest")
      neotest.setup(opts)
    end,
    dependencies = {
      {
        "nvim-neotest/neotest-python",
        ft = { "python" },
      },
    }
  },
  -- Debugger
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "nvim-dap" },
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          automatic_setup = true,
          ensure_installed = { "python" },
          handlers = {
            function(config)
              -- all sources with no handler get passed here

              -- Keep original functionality
              require('mason-nvim-dap').default_setup(config)
            end,
          },
        },
        config = function(opts)
          local mason_nvim_dap = require "mason-nvim-dap"
          mason_nvim_dap.setup(opts)
        end
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        config = true,
      },
      {
        "rcarriga/nvim-dap-ui",
        opts = {
          -- icons = { expanded = "▾", collapsed = "▸" },
          -- mappings = {
          --   -- Use a table to apply multiple mappings
          --   expand = { "<CR>", "<2-LeftMouse>" },
          --   open = "o",
          --   remove = "d",
          --   edit = "e",
          --   repl = "r",
          --   toggle = "t",
          -- },
          -- layouts = {
          --   {
          --     elements = {
          --       "scopes",
          --       "breakpoints",
          --       "stacks",
          --       "watches",
          --     },
          --     size = 80,
          --     position = "left",
          --   },
          --   {
          --     elements = { "repl", "console" },
          --     size = 0.25,
          --     position = "bottom",
          --   },
          -- },
          -- render = {
          --   max_value_lines = 3,
          -- },
          floating = { max_width = 0.9, max_height = 0.5, border = "rounded" },
        },
      },
      {
        "mfussenegger/nvim-dap-python",
        ft = { "python" },
        config = function()
          require("dap-python").setup("~/.config/nvim/.virtualenvs/debugpy/bin/python")
          require('dap-python').test_runner = 'pytest'
        end
      }
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      require('dap.ext.vscode').load_launchjs()
    end,
    keys = {
      {
        "<F2>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step Into"
      },
      {
        "<F3>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step Over"
      },
      {
        "<F4>",
        function()
          local filetype = vim.bo.filetype
          if filetype == "python" then
            require("dap-python").test_method()
          end
        end,
        desc = "Debug: Test"
      },
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Start/Continue"
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step Out"
      },
      {
        "<leader>b",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debug: Toggle Breakpoint"
      },
      {
        "<leader>B",
        function()
          require("dap").set_breakpoint(
            vim.fn.input("Breakpoint condition: ")
          )
        end,
        desc = "Debug: Set Breakpoint"
      },
      {
        "<leader>lp",
        function()
          require("dap").set_breakpoint(
            nil, nil, vim.fn.input("Log point message: ")
          )
        end,
        desc = "Debug: Log point message"
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.open()
        end,
        desc = "Debug: Open REPL"
      },

    },
  },
}
