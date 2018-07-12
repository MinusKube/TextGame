local class = {}

---@param game Game
---@return ModuleManager
function class.new(game)
  ---@type Module
  local currentModule

  ---@class ModuleManager
  local self = {}

  ---@param dt number
  function self.update(dt)
    if currentModule == nil then
      return
    end

    currentModule.run(dt)
  end

  ---@return Module
  function self.getCurrentModule() return currentModule end
  ---@param module Module
  function self.setCurrentModule(module)
    currentModule = module
    currentModule.init()
  end

  return self
end

return class