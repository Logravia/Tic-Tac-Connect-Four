# frozen_string_literal: true

require 'pry-byebug'

# Manages the game - main loop, asking players for input,
# Asking BoardManager to place the input on its board
# Asking DisplayManager to display board's data however it pleases
class GameManager
  # 2D array for 3x3 board
  attr_reader :board_manager, :players, :screen

  def initialize(width, height)
    @board_manager = BoardManager.new(width, height)
    @screen = DisplayManager.new(width, height)
  end

  def play
    screen.update_canvas(board_manager.board)
    screen.show_board
  end

  def reset
    @board = Board.new
  end
end

# Manages how the data of the board ought to be displayed
# Generates an empty ASCII board of width*height squares
# Puts on the ASCII board appropriate symbols depending on the state of the board
# Prints the ASCII board with appropriate symbols onto the console
class DisplayManager
  attr_reader :circle, :cross, :canvas

  def initialize(width, height)
    @circle = { [1, 4] => '0', [2, 3] => '0', [2, 6] => '0', [3, 5] => '0' }
    @cross = { [1, 2] => '#', [1, 6] => '#', [2, 4] => '#', [3, 2] => '#', [3, 6] => '#' }
    @canvas =  gen_canvas(width, height)
  end

  def gen_canvas(width, height)
    slate = []
    height.times do
      gen_horizontal_line(width, slate)
      gen_vertical_line(width, slate)
    end
    gen_horizontal_line(width, slate)
    slate
  end

  def gen_vertical_line(width, slate)
    height = 3
    spacing = 8
    height.times do
      line = []
      width.times do
        line << '|'
        spacing.times do
          line << ' '
        end
      end
      # ending
      line << '|'
      line << "\n"
      slate << line
    end
  end

  def gen_horizontal_line(width, slate)
    spacing = 8
    line = []
    width.times do
      line << '+'
      spacing.times do
        line << '-'
      end
    end
    line << '+'
    line << "\n"
    slate << line
  end

  def show_board
    canvas.each do |row|
      row.each do |val|
        print val
      end
    end
  end

  def put_symbol(symbol, x, y)
    y_offset = 4 * y
    x_offset = 8 * x
    symbol.each do |k, v|
      canvas[k[0] + y_offset][k[1] + x_offset] = v
    end
  end

  def update_canvas(board_state)
    board_state.each_with_index do |row, nth_row|
      row.each_with_index do |val, nth_column|
        case val
        when '1'
          put_symbol(circle, nth_row, nth_column)
        when '2'
          put_symbol(cross, nth_row, nth_column)
        end
      end
    end
  end

  def print_prompt; end
  def print_result; end
  def clear; end
end

# Manages players, e.g. gets input from them, stores their symbols and scores
class Player
  attr_accessor :symbol, :score, :name

  def initialize(name, _ord)
    @order = order
    @name = name
    @score = 0
  end

  def choose
    chosen_square = gets.to_i
  end
end

# Holds data about board of the game - where each player has put their piece.
# Allows a piece to be put on the board.
# Answers whether the game has been won, whether there's a tie or game can be continued.
# Contains all the logic and methods to fulfill this purpose
class BoardManager
  attr_reader :board, :size

  def initialize(width, height, tokens_to_win = 3)
    @board = Array.new(height) { Array.new(width) }
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
          return false unless val.nil?

          # Can only place if the value is nil, return true/false whether placed or not.
          board[y][x] = who
          return true
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

game = GameManager.new(3,3)
game.play
