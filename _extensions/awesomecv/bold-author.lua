-- bold-author.lua
-- Bolds "Marshall, E. W." in bibliography entries
-- Adds † before mentee names (defined in mentees table)

-- Define mentees by last name - need to update with actual last names to use.
local mentees = {
  ["Wilson"] = true,
  ["Day"] = true,
  ["Budell"] = true,
  ["Buhr"] = true,
  ["Danigole"] = true,
  ["Buck"] = true,
  ["McGarry"] = true,
  ["Epp"] = true,
  ["Bohls"] = true,
}

local function is_mentee(name)
  for mentee_name, _ in pairs(mentees) do
    if name == mentee_name .. "," then
      return true
    end
  end
  return false
end

local function process_authors(el)
  local dominated = false
  local i = 1
  while i <= #el.content do
    local current = el.content[i]

    -- Check for Marshall
    if current.t == "Str" and current.text == "Marshall," then
      local name_elements = {current}
      local j = i + 1

      while j <= #el.content and j <= i + 5 do
        local next_el = el.content[j]
        if next_el.t == "Space" then
          table.insert(name_elements, next_el)
          j = j + 1
        elseif next_el.t == "Str" then
          if next_el.text:match("^[A-Z]%.") or next_el.text:match("^[A-Z]$") then
            table.insert(name_elements, next_el)
            j = j + 1
          else
            break
          end
        else
          break
        end
      end

      local bold_name = pandoc.Strong(name_elements)

      for _ = 1, #name_elements - 1 do
        table.remove(el.content, i + 1)
      end
      el.content[i] = bold_name

    -- Check for mentees
    elseif current.t == "Str" and is_mentee(current.text) then
      -- Insert † before the mentee's name
      local dagger = pandoc.Str("†")
      table.insert(el.content, i, dagger)
      i = i + 1  -- Skip past the dagger we just inserted
    end

    i = i + 1
  end
  return el
end

function Para(el)
  return process_authors(el)
end

function Plain(el)
  return process_authors(el)
end
