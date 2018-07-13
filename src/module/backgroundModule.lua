local class = {}

---@param game Game
---@return BackgroundModule
function class.new(game)
  local moduleClass = require("module.module")

  ---@type Character[][]
  local randomCharacters
  ---@type number
  local state = 0

  ---@class BackgroundModule : Module
  local self = moduleClass.new(game, "background")

  ---@type function[]
  local super = {
    run = self.run
  }

  function self.init()
    local characterClass = require("character")
    local characters = game.getCharacters()

    local alphabetText = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local alphabet = {}

    for character in alphabetText:gmatch(".") do
      table.insert(alphabet, character)
    end

    randomCharacters = {}

    for row = 1, #characters do
      randomCharacters[row] = {}

      for column = 1, #characters[row] do
        randomCharacters[row][column] = characterClass.new(alphabet[math.random(#alphabet)],
                { 0.1, 0.1, 0.1 })
      end
    end
  end

  ---@param dt number
  function self.run(dt)
    super.run(dt)

    state = state + dt

    if state >= 0.01 then
      for i = 1, 10 do
        local row = randomCharacters[math.random(#randomCharacters)]
        local firstColumn = row[1]

        for column = 1, #row - 1 do
          row[column] = row[column + 1]
        end

        row[#row] = firstColumn

        if math.random(10) == 1 then
          for column = 1, #row do
            local gray = math.random() / 20 + 0.05

            row[column] = row[column].editColor({ gray, gray, gray })
          end
        else
          for column = 1, #row do
            row[column] = row[column].editColor({ 0.1, 0.1, 0.1 })
          end
        end
      end

      state = 0
    end

    for row = 1, #randomCharacters do
      for column = 1, #randomCharacters[row] do
        game.setCharacter(randomCharacters[row][column], row, column)
      end
    end
  end

  return self
end

return class