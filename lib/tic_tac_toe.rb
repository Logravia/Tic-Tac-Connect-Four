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
    @board = Board.new()
  end
  def play
    loop do
      # Main game loop
    end
  end

  def reset
    @board = Board.new()
  end
end

# Manages what gets put on the screen
class Screen
  attr_reader :circle, :cross

  def initialize
    @circle = { [0, 4] => '#', [1, 2] => '#', [1, 5] => '#', [2, 4] => '#' }
    @cross = { [0, 2] => '#', [0, 6] => '#', [1, 4] => '#', [2, 2] => '#', [2, 6] => '#' }
  end

  def gen_display_board(height)
    arr = []
    height.time do
      arr = gen_horizontal_line(arr)
      arr = gen_vertical_line(arr)
      arr = gen_horizontal_line(arr)
    end
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

  def gen_vertical_line(arr)
    spacing = 8
    height.times do
      line = []
      line << '|'
      spacing.times do
        line << ' '
      end
      line << '|'
      spacing.times do
        line << ' '
      end
      line << '|'
      spacing.times do
        line << ' '
      end
      line << "\n"
      arr << line
    end
    arr
  end

  def gen_horizontal_line(arr)
    spacing = 8
    line = []
    spacing.times do
      line << '-'
    end
    line << '+'
    spacing.times do
      line << '-'
    end
    line << '+'
    spacing.times do
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

  def initialize(name)
    @name = name
    @score = 0
  end

  def choose
    chosen_square = gets
  end
end

class Board
  attr_reader :board, :size

  def initialize(size = 3, tokens_to_win = 3)
    @board = Array.new(size) { Array.new(size) }
    @board_to_draw = []
    @size = size
    @tokens_to_win = tokens_to_win
  end
  def set_token(who, where)

    return false if where > board.length * board[0].length
    # track on which element we are on
    cur_element_num = 1
    board.each_with_index do |row, y|
      row.each_with_index do |val, x|
        if where == cur_element_num
          if val.nil?
            board[y][x] = who
            return true
          else # place already has a value
            return false
          end
        end
        # checked one element time to update the count
        cur_element_num += 1
      end
    end
  end

  # Returns three possible states of the board: tie, unfinished, victory
  def state?
    if victory?
      'victory'
    elsif board.flatten.any?(nil)
      'unfinished'
    else
      'tie'
    end
  end

  private

  attr_reader :tokens_to_win

  # Gets columns of the board
  def columns
    column = []
    arr_of_columns = []
    cur_col = 0
    while cur_col < board[0].length
      cur_row = 0
      while cur_row < board.length
        column << board[cur_row][cur_col]
        cur_row += 1
      end
      cur_col += 1
      arr_of_columns << column
      column = []
    end
    arr_of_columns
  end

  # Gets left or right diagonals of the board
  def l_diagonals(board = self.board)
    start_of_diagonal = 0
    diagonal = []
    arr_of_diagonals = []
    while start_of_diagonal < board[0].length
      cur_col = start_of_diagonal
      cur_row = 0
      while cur_row < board.length && cur_col < board[0].length
        diagonal << board[cur_row][cur_col]
        cur_row += 1
        cur_col += 1
      end
      arr_of_diagonals << diagonal
      diagonal = []
      start_of_diagonal += 1
    end
    arr_of_diagonals
  end

  def r_diagonals
    l_diagonals(board.reverse)
  end

  # True or false if there there are n tokens following each other,
  # in any given selection of tokens (2d array of columns, rows diagonals of the board)
  def n_consec_tokens?(token_collection)
    token_collection.each do |token_row|
      token = token_row[0]
      token_count = 0
      token_row.each do |cell_token|
        if cell_token.nil?
          token_count = 0
          next
        elsif cell_token == token
          token_count += 1
        else
          token_count = 1
          token = cell_token
        end
      end
      return true if token_count == tokens_to_win
    end
    false
  end

  # Returns true  if any of the rows, columns, diagonals contain
  # n consecutive tokens
  def victory?
    rows = board
    if n_consec_tokens?(rows) ||
       n_consec_tokens?(columns)     ||
       n_consec_tokens?(l_diagonals) ||
       n_consec_tokens?(r_diagonals)
      true
    end
  end
end
