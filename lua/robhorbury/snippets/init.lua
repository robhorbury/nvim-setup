local snippet_path = vim.fn.stdpath "config" .. "/lua/robhorbury/snippets"
require("luasnip.loaders.from_lua").load { paths = snippet_path }
