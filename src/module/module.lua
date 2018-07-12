local class = {}

---@param game Game
---@param name string
---@return Module
function class.new(game, name)
  ---@type ModuleDependency[]
  local dependencies = {}

  ---@class Module
  local self = {}

  function self.init() end

  ---@param dt number
  function self.run(dt)
    table.sort(dependencies, function(a, b)
      return a.priority < b.priority
    end)

    for _, dependency in ipairs(dependencies) do
      dependency.module.run(dt)
    end
  end

  ---@return string
  function self.getName() return name end

  ---@return ModuleDependency[]
  function self.getDependencies() return dependencies end

  ---@param name string
  ---@return ModuleDependency
  function self.getDependency(name)
    for _, dependency in ipairs(dependencies) do
      if dependency.module.getName() == name then
        return dependency
      end
    end
  end

  ---@param module Module
  ---@param priority number
  function self.addDependency(module, priority)
    module.init()

    ---@class ModuleDependency
    local dependency = {
      module = module,
      priority = priority
    }

    table.insert(dependencies, dependency)
  end

  ---@param name string
  function self.removeDependency(name)
    for i = #dependencies, 1, -1 do
      local dependency = dependencies[i]

      if dependency.module.getName() == name then
        table.remove(dependencies, i)
      end
    end
  end

  return self
end

return class