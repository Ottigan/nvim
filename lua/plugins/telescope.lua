return {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { -- If encountering errors, see telescope-fzf-native README for installation instructions
            "nvim-telescope/telescope-fzf-native.nvim",

            -- `build` is used to run some command when the plugin is installed/updated.
            -- This is only run then, not every time Neovim starts up.
            build = "make",

            -- `cond` is a condition used to determine whether this plugin should be
            -- installed and loaded.
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
        { "nvim-telescope/telescope-ui-select.nvim" },

        -- Useful for getting pretty icons, but requires a Nerd Font.
        { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
        -- [[ Configure Telescope ]]
        -- See `:help telescope` and `:help telescope.setup()`
        require("telescope").setup({
            defaults = {
                path_display = { "truncate" },
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--glob", -- Enable glob support
                    "!.git/*", -- Exclude .git directory (example)
                },
            },
            pickers = {
                find_files = {
                    -- Use fd for better glob pattern support, or fall back to rg
                    -- With fd, you can search: evo-favorite/**/WinMessage
                    find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
                },
            },
            extensions = {
                ["ui-select"] = { require("telescope.themes").get_dropdown() },
            },
        })

        -- Enable Telescope extensions if they are installed
        pcall(require("telescope").load_extension, "fzf")
        pcall(require("telescope").load_extension, "ui-select")

        -- Find nearest parent directory containing a package marker (package.json, etc.)
        local function find_package_root()
            local markers = { "package.json", "cargo.toml", "go.mod" }
            local current = vim.fn.expand("%:p:h")
            for _, marker in ipairs(markers) do
                local found = vim.fs.find(marker, { path = current, upward = true })[1]
                if found then
                    return vim.fn.fnamemodify(found, ":h")
                end
            end
            return nil
        end

        -- See `:help telescope.builtin`
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
        vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
        -- Enhanced file search
        vim.keymap.set("n", "<leader>sf", function()
            builtin.find_files({
                find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
            })
        end, { desc = "[S]earch [F]iles" })
        vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
        vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
        vim.keymap.set("n", "<leader>sg", function()
            local search_dir = vim.fn.input("Search directory: ", "", "dir")
            if search_dir ~= "" then
                builtin.live_grep({ search_dirs = { search_dir } })
            else -- If no directory is provided, fall back to searching the current working directory
                builtin.live_grep()
            end
        end, { desc = "[S]earch by [G]rep" })
        vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
        vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
        vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
        vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
        vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

        -- Package-scoped search: find files and grep within the nearest package root
        vim.keymap.set("n", "<leader>sp", function()
            local root = find_package_root()
            if root then
                builtin.find_files({ cwd = root, prompt_title = "Files in " .. vim.fn.fnamemodify(root, ":t") })
            else
                builtin.find_files()
            end
        end, { desc = "[S]earch [P]ackage files" })

        vim.keymap.set("n", "<leader>sG", function()
            local root = find_package_root()
            if root then
                builtin.live_grep({
                    search_dirs = { root },
                    prompt_title = "Grep in " .. vim.fn.fnamemodify(root, ":t"),
                })
            else
                builtin.live_grep()
            end
        end, { desc = "[S]earch [G]rep in package" })

        -- LSP-specific Telescope keymaps (set per buffer on LspAttach)
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
            callback = function(event)
                local buf = event.buf

                -- Find references for the word under your cursor.
                vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })

                -- Jump to the implementation of the word under your cursor.
                -- Useful when your language has ways of declaring types without an actual implementation.
                vim.keymap.set(
                    "n",
                    "gri",
                    builtin.lsp_implementations,
                    { buffer = buf, desc = "[G]oto [I]mplementation" }
                )

                -- Jump to the definition of the word under your cursor.
                -- This is where a variable was first declared, or where a function is defined, etc.
                -- To jump back, press <C-t>.
                vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })

                -- Fuzzy find all the symbols in your current document.
                -- Symbols are things like variables, functions, types, etc.
                vim.keymap.set(
                    "n",
                    "gO",
                    builtin.lsp_document_symbols,
                    { buffer = buf, desc = "Open Document Symbols" }
                )

                -- Fuzzy find all the symbols in your current workspace.
                -- Similar to document symbols, except searches over your entire project.
                vim.keymap.set(
                    "n",
                    "gW",
                    builtin.lsp_dynamic_workspace_symbols,
                    { buffer = buf, desc = "Open Workspace Symbols" }
                )

                -- Jump to the type of the word under your cursor.
                -- Useful when you're not sure what type a variable is and you want to see
                -- the definition of its *type*, not where it was *defined*.
                vim.keymap.set(
                    "n",
                    "grt",
                    builtin.lsp_type_definitions,
                    { buffer = buf, desc = "[G]oto [T]ype Definition" }
                )
            end,
        })

        -- Override default behavior and theme when searching
        vim.keymap.set("n", "<leader>/", function()
            -- You can pass additional configuration to Telescope to change the theme, layout, etc.
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                winblend = 10,
                previewer = false,
            }))
        end, { desc = "[/] Fuzzily search in current buffer" })

        -- It's also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
        vim.keymap.set("n", "<leader>s/", function()
            builtin.live_grep({
                grep_open_files = true,
                prompt_title = "Live Grep in Open Files",
            })
        end, { desc = "[S]earch [/] in Open Files" })

        -- Shortcut for searching your Neovim configuration files
        vim.keymap.set("n", "<leader>sn", function()
            builtin.find_files({ cwd = vim.fn.stdpath("config") })
        end, { desc = "[S]earch [N]eovim files" })
    end,
}
