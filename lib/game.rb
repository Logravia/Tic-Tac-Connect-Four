# frozen_string_literal: true

# Manages the game - main loop, asking players for input,
# Asking Board to place the input on its data
# Asking Display to display data's data however it pleases
class Game
  attr_reader :board, :display

  def initialize(width, height, tokens_to_win)
    @board = Board.new(width, height, tokens_to_win)
    @display = Display.new(width, height)
  end

  def process_input(which_player)
    succesful_choice = false
    until succesful_choice
      input = gets.chomp
      exit if input == 'q'
      succesful_choice = board.set_token(which_player, input.to_i)
      puts 'Sorry, that is not a valid choice. Try again or q to quit.' unless succesful_choice
    end
  end

  def print_result(which_player)
    display.show
    if board.victory?
      print "Player #{which_player + 1} won!\n"
    else
      print "It is a tie!\n"
    end
  end

  def play
    turn = 0
    until board.finished? || board.victory?
      display.show
      which_player = turn % 2 # Depending on turn number it is either p0 or p1
      print "Turn of player #{which_player + 1}.\nPick a square: "
      process_input(which_player)
      display.update(board.data)
      turn += 1
    end
    print_result(which_player)
  end
end
