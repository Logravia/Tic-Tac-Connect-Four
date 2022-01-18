# frozen_string_literal: true

require_relative 'board'
require_relative 'game'
require_relative 'display'

WIDTH = { MAX: 12, MIN: 2, STR: 'width' }.freeze
HEIGHT = { MAX: 12, MIN: 2, STR: 'height' }.freeze
TOKENS = { MIN: 2, MAX: 6, STR: 'consecutive tokens to win' }.freeze

def get_num_input
  input = gets.chomp
  if input == 'q'
    exit
  elsif begin
    Integer(input)
  rescue StandardError
    nil
  end.nil?
    puts 'Sorry, not a number. Try again or press q to quit.'
    get_num_input
  else
    input.to_i
  end
end

def get_size(dimension)
  print "Please define #{dimension[:STR]}: "
  size = get_num_input
  if size.between?(dimension[:MIN], dimension[:MAX])
    size
  else
    puts "Sorry, but #{dimension[:STR]} can be between #{dimension[:MIN]} and #{dimension[:MAX]}. Try again or press q to quit."
    get_size(dimension)
  end
end

width = get_size(WIDTH)
height = get_size(HEIGHT)
tokens_to_win = get_size(TOKENS)

game = Game.new(width, height, tokens_to_win)
game.play
