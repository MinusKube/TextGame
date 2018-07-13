local class = {}

---@param game Game
---@return QuitModule
function class.new(game)
  local moduleClass = require("module.module")

  ---@type boolean
  local quitting = false
  ---@type number
  local quittingState = 0

  ---@class QuitModule : Module
  local self = moduleClass.new(game, "quit")

  ---@type function[]
  local super = {
    run = self.run
  }

  function self.init()
  end

  ---@param dt number
  function self.run(dt)
    local characterClass = require("character")

    super.run(dt)

    if not quitting then
      return
    end

    quittingState = quittingState + 15 * dt

    local characters = game.getCharacters()

    math.randomseed(2)

    for i = 1, quittingState do
      for row = 1, #characters do
        for column = 1, #characters[row] do
          if (row == i or row == #characters - i + 1
                  or column == i or column == #characters[row] - i + 1) then

            if (i ~= math.floor(quittingState) or math.random(2) == 1) then
              if math.random(20) ~= 1 or math.abs(i - quittingState) > 3 + math.random(3) then
                game.setCharacter(characterClass.empty(), row, column)
              else
                characters[row][column] = characters[row][column].editColor({ 0.3, 0, 0 })
              end
            else
              local gray = 0.1 - quittingState % 0.1
              characters[row][column] = characters[row][column].editColor({ gray, gray, gray })
            end
          end
        end
      end
    end

    if quittingState >= 30 then
      love.event.quit()
    end
  end

  ---@return boolean
  function self.isQuitting() return quitting end
  ---@param _quitting boolean
  function self.setQuitting(_quitting) quitting = _quitting end

  return self
end

return class