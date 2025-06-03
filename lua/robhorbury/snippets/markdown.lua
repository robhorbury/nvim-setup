local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node
local i = ls.insert_node

return {
  s({ trig = "currdate", dscr = "Insert today's date in YYYY-MM-DD format" }, {
    f(function()
      return os.date "%Y-%m-%d" .. ":" -- Change format as needed
    end, {}),
  }),
  s({ trig = "todo", dscr = "Insert a TODO comment" }, {
    t "- [ ] ",
    i(1, "task description"),
  }),
  s({ trig = "link", dscr = "Markdown link" }, {
    t "[",
    i(1, "text"),
    t "](",
    i(2, "url"),
    t ")",
  }),
  s({ trig = "cb", dscr = "Code block" }, {
    t "```",
    i(1, "language"),
    t { "", "" },
    i(2, "code"),
    t { "", "```" },
  }),
}
