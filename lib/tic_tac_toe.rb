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
  @circle = [[nil,nil,nil, nil,'#',nil,nil,nil],
             [nil,nil,'#',nil,nil,nil,'#',nil],
             [nil,nil,nil,nil,'#',nil,nil,nil]]

  @cross = [[nil,nil,'#', nil,nil,nil, '#',nil],
            [nil,nil,nil,nil,'#',nil,nil,nil],
            [nil,nil,'#', nil,nil,nil, '#',nil]]
  end

  @prompt_text = 'Where are you gonna go?'
  def print_board(board, size)
    width = 8
    height = 3
    vertical_line(width, height)
    horizontal_line(width)
    vertical_line(width, height)
    horizontal_line(width)
    vertical_line(width, height)
  end

  def vertical_line(width, height)
    height.times do
      print(" " * width)
      print('|')
      print(" " * width)
      print('|')
      puts ''
    end
  end
  def horizontal_line(width)
    print("-" * width)
    print("+")
    print("-" * width)
    print("+")
    print("-" * width)
    puts("")
  end

  def print_symbol()
    cross.each() do |row|
      row.each() do |v|
        if v.nil?
          print (' ')
        else
          print v
        end
      end
      puts ("")
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
screen.print_board("",9)
screen.print_symbol()
