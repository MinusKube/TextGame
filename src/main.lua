---@type Game
local game

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")

  local gameClass = require("game")

  game = gameClass.new()
  game.init()
end

function love.update(dt)
  game.update(dt)
end

function love.draw()
  game.draw()
end