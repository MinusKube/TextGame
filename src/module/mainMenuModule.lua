local class = {}

---@param game Game
---@return MainMenuModule
function class.new(game)
  local moduleClass = require("module.module")

  ---@class MainMenuModule : Module
  local self = moduleClass.new(game, "mainMenu")

  function self.init()
    local backgroundModule = require("module.backgroundModule").new(game)
    local asteroidModule = require("module.asteroidModule").new(game)
    local menuModule = require("module.menuModule").new(game)
    local quitModule = require("module.quitModule").new(game)

    self.addDependency(backgroundModule, 1)
    self.addDependency(asteroidModule, 2)
    self.addDependency(menuModule, 3)
    self.addDependency(quitModule, 4)
  end

  return self
end

return class