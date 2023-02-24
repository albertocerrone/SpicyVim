return {
  -- Debugger
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        config = true,
      },
      {
        "rcarriga/nvim-dap-ui",
        opts = {
          icons = { expanded = "▾", collapsed = "▸" },
          mappings = {
            -- Use a table to apply multiple mappings
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
          },
          layouts = {
            {
              elements = {
                "scopes",
                "breakpoints",
                "stacks",
                "watches",
              },
              size = 80,
              position = "left",
            },
            {
              elements = { "repl", "console" },
              size = 0.25,
              position = "bottom",
            },
          },
          render = {
            max_value_lines = 3,
          },
          floating = { max_width = 0.9, max_height = 0.5, border = vim.g.border_chars },
        },
      },
      {
        "mfussenegger/nvim-dap-python",
        ft = { "python" },
        config = function ()
          require("dap-python").setup("~/.config/nvim/.virtualenvs/debugpy/bin/python")
        end
      }
    },
    config = function ()
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
        "<F5>",
        function ()
          require("dap").continue()
        end,
        desc = "Debug: Start/Continue"
      },
      {
        "<F3>",
        function ()
          require("dap").step_over()
        end,
        desc = "Debug: Step Over"
      },
      {
        "<F2>",
        function ()
          require("dap").step_into()
        end,
        desc = "Debug: Step Into"
      },
      {
        "<F12>",
        function ()
          require("dap").step_out()
        end,
        desc = "Debug: Step Out"
      },
      {
        "<leader>b",
        function ()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debug: Toggle Breakpoint"
      },
      {
        "<leader>B",
        function ()
          require("dap").set_breakpoint(
            vim.fn.input("Breakpoint condition: ")
          )
        end,
        desc = "Debug: Set Breakpoint"
      },
      {
        "<leader>lp",
        function ()
          require("dap").set_breakpoint(
            nil,nil,vim.fn.input("Log point message: ")
          )
        end,
        desc = "Debug: Log point message"
      },
      {
        "<leader>dr",
        function ()
          require("dap").repl.open()
        end,
        desc = "Debug: Open REPL"
      },

    },
  },

}
