# frozen_string_literal: true

require 'pry-byebug'

module TicTacToe
  class Error < StandardError; end
end

# Manages the game - main loop, scores, board, board state, two player instances and the screen
class GameManager
  # 2D array for 3x3 board
  attr_reader :board

  def initialize
    @board = Array.new(3) { Array.new(3) }
    @players = []
    @score = []
    @screen = nil
  end

  def board_state?
    # TODO: refactor checks
    # horizontal check
    @board.each do |row|
      return 'victory' if n_consecutive?(row[0], row, 3)
    end

    # vertical check
    column = 0
    while column < 3
      row = 0
      token = @board[row][column]
      token_count = 0
      while row < 3
        break if @board[row][column].nil?

        token_count += 1 if @board[row][column] == token
        # go down the row
        row += 1
      end
      return 'victory' if token_count == 3

      # finished one column, moving on to next
      column += 1
    end

    # main diagonal check
    column = 0
    row = 0
    token = @board[0][0]
    token_count = 0
    while column < 3
      break if @board[row][column].nil?

      token_count += 1 if @board[row][column] == token
      # go diagonally to next part
      row += 1
      column += 1
    end
    return 'victory' if token_count == 3

    # reverse diagonal check
    column = 0
    row = 2
    token = @board[row][column]
    token_count = 0
    while column < 3
      break if @board[row][column].nil?

      token_count += 1 if @board[row][column] == token
      # go diagonally to next part
      row -= 1
      column += 1
    end
    return 'victory' if token_count == 3

    # none of the victory conditions were achieved therefore the board can be unfinished or tied
    # while there is a nil, there's a place to make a move, board can't be finished
    @board.flatten.include?(nil) ? 'unfinished' : 'tie'
  end

  # returns true when elements are consecutively in a row n times
  def n_consecutive?(token, row, num)
    token_count = 0
    row.each do |cell_token|
      break if cell_token.nil?

      if token == cell_token
        token_count += 1
      else
        token_count = 0
      end
    end
    token_count == num
  end

  def play
    loop do
      # Main game loop
    end
  end

  def next_round
    # Move player's to round n
  end

  def read_move(player)
    # Get a move from the player
    # Check its validity
  end

  def write_move(where, player); end

  def reset
    @board = Array.new(3) { Array.new(3) }
    @screen.clear
  end
end

# Manages what gets put on the screen
class Screen
  attr_reader :circle, :cross

  def initialize
    @circle = { [0, 4] => '#', [1, 2] => '#', [1, 5] => '#', [2, 4] => '#' }
    @cross = { [0, 2] => '#', [0, 6] => '#', [1, 4] => '#', [2, 2] => '#', [2, 6] => '#' }
  end

  def print_board(_board, _size)
    width = 8
    height = 3
    vertical_line(width, height)
    horizontal_line(width)
    vertical_line(width, height)
    horizontal_line(width)
    vertical_line(width, height)
  end

  def gen_display_board(_width = 8, _height = 3)
    arr = []
    arr = gen_vertical_line(arr)
    arr = gen_horizontal_line(arr)
    arr = gen_vertical_line(arr)
    arr = gen_horizontal_line(arr)
    arr = gen_vertical_line(arr)
  end

  def board_arr_to_hash(arr)
    hash = {}
    arr.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        hash[[x, y]] = cell
      end
    end
    hash
  end

  def gen_vertical_line(arr, width = 8, height = 3)
    height.times do
      line = []
      width.times do
        line << ' '
      end
      line << '|'
      width.times do
        line << ' '
      end
      line << '|'
      width.times do
        line << ' '
      end
      line << "\n"
      arr << line
    end
    arr
  end

  def gen_horizontal_line(arr, width = 8)
    line = []
    width.times do
      line << '-'
    end
    line << '+'
    width.times do
      line << '-'
    end
    line << '+'
    width.times do
      line << '-'
    end
    line << "\n"
    arr << line
  end
  def print_symbol(arr)
    arr.each do |row|
      row.each do |v|
        if v.nil?
          print(' ')
        else
          print v
        end
      end
      puts('')
    end
  end
  def print_hash_canvas(hash)
    hash.each do |_k, v|
      print v
    end
  end
  def put_symbol(hash, x, y)
    y_offset = 4 * y
    x_offset = 8 * x
    cross.each do |k, v|
      hash[[k[0] + y_offset, k[1] + x_offset]] = v
    end
  end
  def print_prompt; end
  def print_result; end
  def clear; end
end

# Manages players, e.g. gets input from them, stores their symbols and scores
class Player
  attr_accessor :symbol, :score

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @score = 0
  end

  def choose(choice)
    # get a choice
    # return it
  end
end

screen = Screen.new
canvas_arr = screen.gen_display_board
hash = screen.board_arr_to_hash(canvas_arr)
screen.print_hash_canvas(hash)
