local class = {}

---@param game Game
---@return MenuModule
function class.new(game)
  local moduleClass = require("module.module")

  ---@type MenuButton[]
  local buttons = {}

  ---@type number
  local minRow, minColumn
  ---@type number
  local maxRow, maxColumn

  ---@type boolean
  local closing = false
  ---@type number
  local closeState = 0

  ---@class MenuModule : Module
  local self = moduleClass.new(game, "menu")

  ---@type function[]
  local super = {
    run = self.run
  }

  function self.init()
    minRow = 30
    minColumn = 10
    maxRow = 40
    maxColumn = 70

    ---@param text string
    ---@param index number
    ---@param action function
    local function createMenuButton(text, index, action)
      ---@class MenuButton
      local button = {}
      button.text = text
      button.row = minRow + 3 + (index - 1) * 2
      button.action = action

      --[[button.hoveredText = text .. " "

      while #button.hoveredText < (maxColumn - minColumn - 3) do
        button.hoveredText = button.hoveredText .. "#"
      end]]

      button.hoveredText = "O" .. text:sub(2)

      table.insert(buttons, button)
    end

    createMenuButton("# PLAY", 1, function()
      closing = true
    end)

    createMenuButton("# OPTIONS", 2, function() end)

    createMenuButton("# QUIT", 3, function()
      local quitModule = game.getModuleManager().getCurrentModule().getDependency("quit").module
      quitModule.setQuitting(true)
    end)
  end

  ---@param dt number
  function self.run(dt)
    local characterClass = require("character")

    super.run(dt)

    if closing then
      closeState = closeState + dt

      if closeState >= 0.01 then
        closeState = 0

        if minRow > 2 then
          minRow = minRow - 1
        end

        if maxRow < #game.getCharacters() - 1 then
          maxRow = maxRow + 1
        end

        if minColumn > 2 then
          minColumn = minColumn - 1
        end

        if maxColumn < #game.getCharacters()[1] - 1 then
          maxColumn = maxColumn + 1
        end
      end
    end

    if minRow >= maxRow then
      return
    end

    game.fillRect(characterClass.empty(), minRow, minColumn, maxRow, maxColumn)

    local characters = game.getCharacters()

    for row = 1, #characters do
      for column = 1, #characters[row] do
        if ((row == minRow or row == maxRow) and column >= minColumn and column <= maxColumn) or
                ((column == minColumn or column == maxColumn) and row >= minRow and row <= maxRow) then

          game.setCharacter(characterClass.new("#", { 0.2, 0.2, 0.2 }),
                  row, column)
        end
      end
    end

    local hoveredRow, hoveredColumn = game.getHoveredPosition()

    for _, button in ipairs(buttons) do
      if not closing then
        if hoveredRow == button.row and hoveredColumn >= minColumn + 2 and hoveredColumn <= maxColumn - 2 then
          game.setText(characterClass.newText(button.hoveredText, { 0.5, 0.5, 0.8 }),
                  button.row, minColumn + 2)

          if love.mouse.isDown(1) then
            button.action()
          end
        else
          game.setText(characterClass.newText(button.text), button.row, minColumn + 2)
        end
      end
    end
  end

  return self
end

return class