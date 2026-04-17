return {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "nvim-tree/nvim-web-devicons",              enabled = vim.g.have_nerd_font },
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
                    "--glob",  -- Enable glob support
                    "!.git/*", -- Exclude .git directory (example)
                },
            },
            pickers = {
                buffers = {
                    mappings = {
                        n = {
                            ["dd"] = require("telescope.actions").delete_buffer, -- Use 'dd' in normal mode
                        },
                        i = {
                            ["<C-d>"] = require("telescope.actions").delete_buffer, -- Keep using '<C-d>' in insert mode
                        },
                    },
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
            local markers = { "package.json", "Cargo.toml", "go.mod" }
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
        vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
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
