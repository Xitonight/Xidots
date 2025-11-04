local helpers = require "snippets.helper_functions"
local autosnippet = helpers.autosnippet
local line_begin = helpers.line_begin

return {
  autosnippet(
    { trig = "([^%a])EE", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>_, err := <>
      if err != nil {
        <>
      }
]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
      }
    ),
    { condition = line_begin }
  ),
}
