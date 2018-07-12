local class = {}

---@return Game
function class.new()
  ---@type Font
  local font
  ---@type Character[][]
  local characters

  ---@type number
  local hoveredRow, hoveredColumn = 0, 0

  ---@type ModuleManager
  local moduleManager

  ---@class Game
  local self = {}

  function self.init()
    local characterClass = require("character")

    font = love.graphics.newImageFont("resources/font.png",
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789#", 1)
    characters = {}

    for row = 1, 45 do
      characters[row] = {}

      for column = 1, 80 do
        characters[row][column] = characterClass.empty()
      end
    end

    local mainMenuModuleClass = require("module.mainMenuModule")
    local moduleManagerClass = require("module.moduleManager")

    moduleManager = moduleManagerClass.new(self)
    moduleManager.setCurrentModule(mainMenuModuleClass.new(self))
  end

  ---@param dt number
  function self.update(dt)
    local mouseX, mouseY = love.mouse.getPosition()

    hoveredRow = math.floor((mouseY / 2) / 8 + 1)
    hoveredColumn = math.floor(((mouseX / 2) - 1) / 8 + 1)

    moduleManager.update(dt)
  end

  function self.draw()
    love.graphics.push()
    love.graphics.scale(2, 2)

    love.graphics.setFont(font)

    for row = 1, #characters do
      for column = 1, #characters[row] do
        local x = (column - 1) * 8 + 1
        local y = (row - 1) * 8

        love.graphics.setColor(characters[row][column].color)
        love.graphics.print(characters[row][column].character, x, y)
      end
    end

    love.graphics.pop()
  end

  ---@param character Character
  ---@param row number
  ---@param column number
  function self.setCharacter(character, row, column)
    if row >= 1 and row <= #characters and column >= 1 and column <= #characters[row] then
      characters[row][column] = character
    end
  end

  ---@param character Character
  ---@param minRow number
  ---@param minColumn number
  ---@param maxRow number
  ---@param maxColumn number
  function self.fillRect(character, minRow, minColumn, maxRow, maxColumn)
    for row = minRow, maxRow do
      for column = minColumn, maxColumn do
        self.setCharacter(character, row, column)
      end
    end
  end

  ---@param text Character[]
  ---@param row number
  ---@param column number
  function self.setText(text, row, column)
    local index = 0

    for _, character in ipairs(text) do
      self.setCharacter(character, row, column + index)

      index = index + 1
    end
  end

  ---@param row number
  ---@param column number
  ---@return Character
  function self.getCharacter(row, column)
    if row < 1 or row > #characters or column < 1 or column > #characters[row] then
      return nil
    end

    return characters[row][column]
  end

  ---@return Character[][]
  function self.getCharacters() return characters end

  ---@return number, number
  function self.getHoveredPosition() return hoveredRow, hoveredColumn end

  ---@return ModuleManager
  function self.getModuleManager() return moduleManager end

  return self
end

return class