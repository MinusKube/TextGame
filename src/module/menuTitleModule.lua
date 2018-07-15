local class = {}

---@param game Game
---@return MenuTitleModule
function class.new(game)
  local moduleClass = require("module.module")

  ---@type ImageModule
  local imageModule

  ---@type boolean
  local jumping = false
  ---@type number
  local jumpState = 0

  ---@class MenuTitleModule : Module
  local self = moduleClass.new(game, "menuTitle")

  ---@type function[]
  local super = {
    run = self.run
  }

  function self.init()
    local characterClass = require("character")

    imageModule = require("module.imageModule").new(
            game,
            love.image.newImageData("resources/title.png"),
            characterClass.new("#", { 0.5, 0.4, 0.6 }),
            15, 19
    )

    self.addDependency(imageModule, 0)
  end

  ---@param dt number
  function self.run(dt)
    super.run(dt)

    if love.keyboard.isDown("space") and not jumping then
      jumping = true
      jumpState = 0
    end

    if jumping then
      jumpState = jumpState + dt

      imageModule.setStartPosition(15 - math.floor(math.sin(jumpState * 10) * 5), 19)

      if jumpState >= 0.31 then
        jumping = false
      end
    end
  end

  return self
end

return class