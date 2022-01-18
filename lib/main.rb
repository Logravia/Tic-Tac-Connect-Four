# frozen_string_literal: true

require_relative 'board.rb'
require_relative 'game.rb'
require_relative 'display.rb'

game = Game.new(3, 3, 3)
game.play
