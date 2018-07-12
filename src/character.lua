local class = {}

---@param character string
---@param color number[]
---@return Character
function class.new(character, color)
  ---@class Character
  local self = {}

  self.character = character
  self.color = color or { 1, 1, 1 }

  return self
end

---@param text string
---@param color number[]
---@return Character[]
function class.newText(text, color)
  ---@type Character[]
  local characters = {}

  for character in text:gmatch(".") do
    table.insert(characters, class.new(character, color))
  end

  return characters
end

---@return Character
function class.empty() return class.new(" ") end

return class