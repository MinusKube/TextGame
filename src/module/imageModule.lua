local class = {}

---@param game Game
---@param data ImageData
---@param character Character
---@param startRow number
---@param startColumn number
---@return ImageModule
function class.new(game, data, character, startRow, startColumn)
  local moduleClass = require("module.module")

  ---@type boolean[][]
  local characters

  ---@class ImageModule : Module
  local self = moduleClass.new(game, "image")

  ---@type function[]
  local super = {
    run = self.run
  }

  function self.init()
    characters = {}

    for row = 1, data:getHeight() do
      characters[row] = {}

      for column = 1, data:getWidth() do
        local _, _, _, alpha = data:getPixel(column - 1, row - 1)

        if alpha > 0.5 then
          characters[row][column] = true
        else
          characters[row][column] = false
        end
      end
    end
  end

  ---@param dt number
  function self.run(dt)
    super.run(dt)

    for row = 1, #characters do
      for column = 1, #characters[row] do
        if characters[row][column] then
          game.setCharacter(character, startRow + row, startColumn + column)
        end
      end
    end
  end

  ---@return Character
  function self.getCharacter() return character end
  ---@param _character Character
  function self.setCharacter(_character) character = _character end

  ---@return number, number
  function self.getStartPosition() return startRow, startColumn end
  ---@param row number
  ---@param column number
  function self.setStartPosition(row, column)
    startRow = row
    startColumn = column
  end

  return self
end

return class