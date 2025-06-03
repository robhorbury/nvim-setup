local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({ trig = "def", dscr = "Function definition" }, {
    t "def ",
    i(1, "function_name"),
    t "(",
    i(2, "params"),
    t { "):", "    " },
    i(0),
  }),

  s({ trig = "class", dscr = "Class definition" }, {
    t "class ",
    i(1, "ClassName"),
    t { ":", "    def __init__(self, " },
    i(2),
    t { "):", "        " },
    i(0),
  }),

  s({ trig = "ifmain", dscr = "`if __name__ == '__main__'` block" }, {
    t { "if __name__ == '__main__':", "    " },
    i(0),
  }),

  s({ trig = "imp", dscr = "Import module" }, {
    t "import ",
    i(1, "module"),
  }),

  s({ trig = "pri", dscr = "Print statement" }, {
    t "print(",
    i(1, "'Hello, world!'"),
    t ")",
  }),

  s({ trig = "#COMMAND", desc = "Databricks Cell" }, {
    t { "# COMMAND ----------" },
  }),
}
