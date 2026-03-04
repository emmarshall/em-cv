-- apa-bib-section.lua
-- Transforms ::: apa-bib divs into Typst apa-bib-section function calls

function Div(el)
  if el.classes:includes("apa-bib") then
    local mentee_note = el.attributes["mentee-note"] == "true"

    local opening
    if mentee_note then
      opening = pandoc.RawBlock("typst", "#v(0.5em)\n#apa-bib-section(mentee-note: true)[")
    else
      opening = pandoc.RawBlock("typst", "#v(0.5em)\n#apa-bib-section()[")
    end

    local closing = pandoc.RawBlock("typst", "]\n#v(0.75em)")

    -- Build new content: opening + original content + closing
    local new_content = pandoc.List({opening})
    new_content:extend(el.content)
    new_content:insert(closing)

    return new_content
  end
end
