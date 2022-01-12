# frozen_string_literal: true

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
    # horizontal check
    @board.each do |row|
      start_token = row[0]
      token_count = 0
      row.each do |cell_token|
        break if cell_token.nil?
        token_count += 1 if start_token == cell_token
      end
      return 'victory' if token_count == 3
    end
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
  @prompt_text = 'Where are you gonna go?'
  def print_board(board); end

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
