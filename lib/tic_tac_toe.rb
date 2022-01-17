# frozen_string_literal: true

require 'pry-byebug'

# Manages the game - main loop, asking players for input,
# Asking BoardManager to place the input on its board
# Asking CanvasManager to display board's data however it pleases
class GameManager
  attr_reader :board, :players, :canvas

  def initialize(width, height, tokens_to_win)
    @board = BoardManager.new(width, height, tokens_to_win)
    @canvas = CanvasManager.new(width, height)
  end

  def play
    turn = 0
    canvas.show
    canvas.number_squares()
    until board.finished? or board.victory?
      which_player = turn % 2 # Depending on turn number it is either p0 or p1
      succesful_choice = false

      puts "Turn of player #{which_player + 1 }."

      until succesful_choice
        choice = gets.chomp # Chooses a square to put his token on
        # set_token returns bool on whether the choice was legitmate
        exit if choice == 'q'
        succesful_choice = board.set_token(which_player, choice.to_i)
        puts 'Sorry, that is not a valid choice. Try again. Q to quit.' unless succesful_choice
      end

      canvas.update(board.board)
      canvas.show
      turn += 1
    end

    if board.victory?
      print "Player #{which_player + 1} won!\n"
    else
      print "It is a tie!\n"
    end

  end

  def reset
    # TODO: implement the two functions
    board.reset
    canvas.reset
  end
end

# Holds data about board of the game - where each player has put their piece.
# Allows a piece to be put on the board.
# Answers whether the game has been won, whether there's a tie or the game is unfinished
# Contains all the logic and methods necessery to fulfill these three actions
class BoardManager
  attr_reader :board, :size

  def initialize(width, height, tokens_to_win = 3)
    @board = Array.new(height) { Array.new(width) }
    @tokens_to_win = tokens_to_win
  end

  def set_token(who, where)
    # TODO: Move validation to a different function
    return false if where > board.length * board[0].length || where <= 0

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

  def tie?
    finished? and not victory?
  end

  def finished?
    return board.flatten.none?(nil)
  end

  def victory?
    # When there are n consecutive tokens in any array on a board e.g. 3 X's in a row returns true
    rows = board
    if n_consec_tokens?(rows) ||
       n_consec_tokens?(columns)     ||
       n_consec_tokens?(l_diagonals) ||
       n_consec_tokens?(r_diagonals)
      true
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
end

# Manages how the data of the board ought to be displayed
# Generates an empty ASCII board of width*height squares
# Puts on the ASCII board appropriate symbols depending on the state of the board
# Prints the ASCII board with appropriate symbols onto the console
class CanvasManager
  def initialize(width, height)
    @circle = { [1, 4] => '0', [2, 3] => '0', [2, 6] => '0', [3, 5] => '0' }
    @cross = { [1, 3] => '#', [1, 7] => '#', [2, 5] => '#', [3, 3] => '#', [3, 7] => '#' }
    @canvas =  gen_canvas(width, height)
  end

  # Updates the ASCII canvas
  # Puts symbols (cross,circle)
  # In all the ASCCII squares where p1 or p2 has put their mark on the board
  def update(board)
    board.each_with_index do |row, nth_row|
      row.each_with_index do |val, nth_column|
        case val
        when 0
          put_symbol(circle, nth_row, nth_column)
        when 1
          put_symbol(cross, nth_row, nth_column)
        end
      end
    end
  end

  def show
    canvas.each do |row|
      row.each do |val|
        print val
      end
    end
  end

#  private

  attr_reader :circle, :cross, :canvas

  def number_squares
    square_num = 1
    canvas.each_with_index do |row, i|
      row.each_with_index do |val, j|
        if val == '|' and canvas[i-1][2] == '-' and row[j+1] != "\n"
          row[j+1] = square_num
          square_num += 1
        end
      end

    end
  end

  # Puts given symbol (cross, circle) onto the ASCII canvas contained in an array
  def put_symbol(symbol, x, y)
    y_offset = 9 * y
    x_offset = 4 * x
    symbol.each do |k, v|
      canvas[k[0] + x_offset][k[1] + y_offset] = v
    end
  end


  # Generates the ASCII board array with the help of gen_vertical_lines and gen_horizontal line
  def gen_canvas(width, height)
    slate = []
    height.times do
      gen_horizontal_lines(width, slate)
      gen_vertical_lines(width, slate)
    end
    gen_horizontal_lines(width, slate)
    slate
  end

  # Generates the vertical parts of an ASCII squares
  def gen_vertical_lines(width, slate)
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

  # Generates the horizontal parts of the ASCII squares
  def gen_horizontal_lines(width, slate)
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
end

# Manages player, e.g. gets input from player,

game = GameManager.new(3, 3, 3)
game.play
