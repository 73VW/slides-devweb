local lang = 'english'

local before = pandoc.RawInline('tex', '\\begin{otherlanguage}{' .. lang .. '}')
local after = pandoc.RawInline('tex', '\\end{otherlanguage}')

local meta = {}

return {
  -- remove the metadata
  {
    Meta = function (el)
      meta = el
      return {}
    end
  },
  -- modify any code element
  {
    Code = function (code)
      return {before, code, after}
    end,

    CodeBlock = function (code_block)
      return {pandoc.Para({before}), code_block, pandoc.Para({after})}
    end,

    RawBlock = function (raw_block)
      return {pandoc.Para({before}), raw_block, pandoc.Para({after})}
    end,
  },
  -- restore the metadata
  {
    Meta = function(_)
      meta['babel-otherlangs'] = lang
      meta['polyglossia-otherlangs'] = {name = lang}
      return meta
    end
  }
}
