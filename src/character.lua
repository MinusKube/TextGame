local class = {}

---@param character string
---@param color number[]
---@return Character
function class.new(character, color)
  color = color or { 1, 1, 1 }

  ---@class Character
  local self = {}

  ---@param newCharacter string
  ---@return Character
  function self.editCharacter(newCharacter)
    return class.new(newCharacter, color)
  end

  ---@param newColor number[]
  ---@return Character
  function self.editColor(newColor)
    return class.new(character, newColor)
  end

  ---@return string
  function self.getCharacter() return character end
  ---@return number[]
  function self.getColor() return color end

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