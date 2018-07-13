local class = {}

---@param game Game
---@return MainMenuModule
function class.new(game)
  local moduleClass = require("module.module")

  ---@class MainMenuModule : Module
  local self = moduleClass.new(game, "mainMenu")

  function self.init()
    local characterClass = require("character")

    local backgroundModule = require("module.backgroundModule").new(game)
    local asteroidModule = require("module.asteroidModule").new(game)
    local menuModule = require("module.menuModule").new(game)
    local quitModule = require("module.quitModule").new(game)
    local titleModule = require("module.imageModule").new(
            game,
            love.image.newImageData("resources/title.png"),
            characterClass.new("#", { 0.5, 0.4, 0.6 }),
            5, 10
    )

    self.addDependency(backgroundModule, 1)
    self.addDependency(asteroidModule, 2)
    self.addDependency(menuModule, 4)
    self.addDependency(quitModule, 5)
    self.addDependency(titleModule, 3)
  end

  return self
end

return class