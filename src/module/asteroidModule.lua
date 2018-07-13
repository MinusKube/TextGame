local class = {}

---@param game Game
---@return AsteroidModule
function class.new(game)
  local moduleClass = require("module.module")

  ---@type Asteroid[]
  local asteroids = {}
  ---@type number
  local spawnTimer = 0

  ---@class AsteroidModule : Module
  local self = moduleClass.new(game, "asteroid")

  ---@type function[]
  local super = {
    run = self.run
  }

  function self.init()
    ---@class Asteroid
    local asteroid = {}
    asteroid.row = 5
    asteroid.column = 60
    asteroid.angle = math.rad(45 + math.random(90))

    table.insert(asteroids, asteroid)
  end

  ---@param dt number
  function self.run(dt)
    local characterClass = require("character")

    super.run(dt)

    spawnTimer = spawnTimer + dt

    if spawnTimer >= 1.5 then
      spawnTimer = 0

      table.insert(asteroids, {
        row = -5,
        column = 10 + math.random(60),
        angle = math.rad(45 + math.random(90))
      })
    end

    for _, asteroid in ipairs(asteroids) do
      for row = math.floor(asteroid.row - 4), asteroid.row + 4 do
        for column = math.floor(asteroid.column - 4), asteroid.column + 4 do
          local distance = math.pow(row - asteroid.row, 2) + math.pow(column - asteroid.column, 2)

          if distance <= 4 * 4 then
            local oldCharacter = game.getCharacter(row, column)

            if oldCharacter ~= nil then
              local color = {
                oldCharacter.getColor()[1] + 0.1,
                oldCharacter.getColor()[2] + 0.1,
                oldCharacter.getColor()[3] + 0.1
              }

              local character = characterClass.new(
                      oldCharacter.getCharacter(),
                      color
              )

              game.setCharacter(character, row, column)
            end
          end
        end
      end

      asteroid.row = asteroid.row + 50 * math.sin(asteroid.angle) * dt
      asteroid.column = asteroid.column + 50 * math.cos(asteroid.angle) * dt
    end
  end

  return self
end

return class