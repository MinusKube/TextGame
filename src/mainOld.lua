local characterClass = require("character")

---@type Font
local font

---@type string[]
local alphabet
---@type Character[][]
local characters

---@type Character[][]
local randomCharacters

---@type number
local state = 0

---@type boolean
local quitting = false
---@type number
local quittingState = 0

---@type number
local hoveredRow, hoveredColumn = 0, 0

---@param character Character
---@param row number
---@param column number
local function setCharacter(character, row, column)
  if row >= 1 and row <= #characters and column >= 1 and column <= #characters[row] then
    characters[row][column] = character
  end
end

---@param character Character
---@param minRow number
---@param minColumn number
---@param maxRow number
---@param maxColumn number
local function fillRect(character, minRow, minColumn, maxRow, maxColumn)
  for row = minRow, maxRow do
    for column = minColumn, maxColumn do
      setCharacter(character, row, column)
    end
  end
end

---@param text Character[]
---@param row number
---@param column number
local function setText(text, row, column)
  local index = 0

  for _, character in ipairs(text) do
    setCharacter(character, row, column + index)

    index = index + 1
  end
end

local function loadMenu()
  for row = 1, #randomCharacters do
    for column = 1, #randomCharacters[row] do
      characters[row][column] = randomCharacters[row][column]
    end
  end

  fillRect(characterClass.empty(), 5, 5, 11, 25)

  setCharacter(characterClass.empty(), hoveredRow - 1, hoveredColumn)
  setCharacter(characterClass.empty(), hoveredRow, hoveredColumn - 1)
  setCharacter(characterClass.empty(), hoveredRow + 1, hoveredColumn)
  setCharacter(characterClass.empty(), hoveredRow, hoveredColumn + 1)

  setCharacter(characterClass.new("O", { 1, 0, 0 }), hoveredRow, hoveredColumn)

  ---@param text string
  ---@param row number
  ---@param column number
  ---@param action function
  local function createMenuText(text, row, action)
    local color = { 1, 1, 1 }

    if hoveredRow == row and hoveredColumn >= 6 and hoveredColumn < 6 + #text then
      color = { 0.5, 0.5, 0.75 }

      text = text .. " "

      while #text <= 18 do
        text = text .. "#"
      end

      if love.mouse.isDown(1) then
        action()
      end
    end

    setText(characterClass.newText(text, color), row, 6)
  end

  createMenuText("PLAY", 6, function() end)
  createMenuText("OPTIONS", 8, function() end)
  createMenuText("QUIT", 10, function() quitting = true end)
end

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")

  local alphabetText = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  alphabet = {}

  for character in alphabetText:gmatch(".") do
    table.insert(alphabet, character)
  end

  font = love.graphics.newImageFont("resources/font.png",
          "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789#", 1)
  characters = {}
  randomCharacters = {}

  for row = 1, 44 do
    characters[row] = {}

    for column = 1, 80 do
      characters[row][column] = characterClass.empty()
    end
  end

  for row = 1, #characters do
    randomCharacters[row] = {}

    for column = 1, #characters[row] do
      randomCharacters[row][column] = characterClass.new(alphabet[math.random(#alphabet)],
              { 0.1, 0.1, 0.1 })
    end
  end

  loadMenu()
end

function love.update(dt)
  local mouseX, mouseY = love.mouse.getPosition()
  hoveredRow = math.floor(((mouseY / 2) - 5) / 8 + 1)
  hoveredColumn = math.floor(((mouseX / 2) - 1) / 8 + 1)

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
          local gray = math.random() / 8

          row[column].color = { gray, gray, gray }
        end
      else
        for column = 1, #row do
          row[column].color = { 0.1, 0.1, 0.1 }
        end
      end
    end

    state = 0
  end

  loadMenu()

  if quitting then
    quittingState = quittingState + 15 * dt

    math.randomseed(2)

    for i = 1, quittingState do
      for row = 1, #characters do
        for column = 1, #characters[row] do
          if (row == i or row == #characters - i + 1
                  or column == i or column == #characters[row] - i + 1) then

            if (i ~= math.floor(quittingState) or math.random(2) == 1) then
              if math.random(20) ~= 1 or math.abs(i - quittingState) > 3 + math.random(3) then
                setCharacter(characterClass.empty(), row, column)
              else
                characters[row][column].color = { 0.5, 0, 0 }
              end
            else
              local gray = 0.1 - quittingState % 0.1
              characters[row][column].color = { gray, gray, gray }
            end
          end
        end
      end
    end

    if quittingState >= 30 then
      love.event.quit()
    end
  end
end

function love.draw()
  love.graphics.push()
  love.graphics.scale(2, 2)

  love.graphics.setFont(font)

  for row = 1, #characters do
    for column = 1, #characters[row] do
      local x = (column - 1) * 8 + 1
      local y = (row - 1) * 8 + 5

      love.graphics.setColor(characters[row][column].color)
      love.graphics.print(characters[row][column].character, x, y)
    end
  end

  love.graphics.pop()
end