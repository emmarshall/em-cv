-- apa-cv-filter.lua
-- Process citations for CV with author highlighting

PANDOC_VERSION:must_be_at_least '2.11'

local highlight_authors = {}

-- Get highlight author from metadata
function Meta(meta)
  if meta["highlight-author"] then
    local ha = meta["highlight-author"]
    local ha_type = pandoc.utils.type(ha)
    if ha_type == "Inlines" then
      table.insert(highlight_authors, pandoc.utils.stringify(ha))
    elseif ha_type == "List" then
      for _, v in ipairs(ha) do
        table.insert(highlight_authors, pandoc.utils.stringify(v))
      end
    else
      table.insert(highlight_authors, pandoc.utils.stringify(ha))
    end
  end
  return meta
end

-- Check if text should be highlighted
local function should_highlight(text)
  if not text then return false end
  for _, author in ipairs(highlight_authors) do
    if text:match(author) then
      return true
    end
  end
  return false
end

-- Process inlines to bold author names
local function process_inlines(inlines)
  local result = pandoc.List()

  for _, elem in ipairs(inlines) do
    if elem.t == "Str" and should_highlight(elem.text) then
      result:insert(pandoc.Strong(pandoc.Str(elem.text)))
    elseif elem.t == "Link" then
      local new_link = elem:clone()
      new_link.content = process_inlines(elem.content)
      result:insert(new_link)
    elseif elem.t == "Emph" then
      result:insert(pandoc.Emph(process_inlines(elem.content)))
    elseif elem.t == "Strong" then
      result:insert(pandoc.Strong(process_inlines(elem.content)))
    elseif elem.t == "Span" then
      local new_span = elem:clone()
      new_span.content = process_inlines(elem.content)
      result:insert(new_span)
    else
      result:insert(elem)
    end
  end

  return result
end

-- Process Cite elements
function Cite(ct)
  ct.content = process_inlines(ct.content)
  if FORMAT:match("typst") then
    return ct.content
  end
  return ct
end

-- Process refs Div
function Div(el)
  if el.identifier and el.identifier:match("^refs") then
    el = el:walk {
      Para = function(para)
        para.content = process_inlines(para.content)
        return para
      end,
      Plain = function(plain)
        plain.content = process_inlines(plain.content)
        return plain
      end
    }
  end
  return el
end

-- Run citeproc
function Pandoc(doc)
  return pandoc.utils.citeproc(doc)
end

return {
  { Meta = Meta },
  { Pandoc = Pandoc },
  { Cite = Cite },
  { Div = Div }
}
