# frozen_string_literal: true

require_relative 'board.rb'
require_relative 'game.rb'
require_relative 'display.rb'

WIDTH = {MAX: 12, MIN: 2, STR: "width"}
HEIGHT = {MAX: 12, MIN: 2, STR: "height"}
TOKENS = {MIN: 2, MAX: 6, STR: "consecutive tokens to win"}

def get_num_input
  input = gets.chomp
  if input == 'q'
    exit
  elsif (Integer(input) rescue nil).nil?
    puts "Sorry, not a number. Try again or press q to quit."
    get_num_input
  else
    return input.to_i
  end
end

def get_size(dimension)
  print "Please define #{dimension[:STR]}: "
  size = get_num_input
  if size.between?(dimension[:MIN], dimension[:MAX])
    return size
  else
    puts "Sorry, but #{dimension[:STR]} can be between #{DIMENSION[:MIN]} and #{DIMENSION[:MAX]}. Try again or press q to quit."
    get_size(dimension)
  end
end

width = get_size(WIDTH)
height = get_size(HEIGHT)
tokens_to_win = get_size(TOKENS)


game = Game.new(width, height, tokens_to_win)
game.play
