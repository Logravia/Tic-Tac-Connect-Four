# frozen_string_literal: true


# Holds data about board of the game - where each player has put their piece.
# Allows a piece to be put on the board.
# Answers whether the game has been won, whether there's a tie or the game is unfinished
# Contains all the logic and methods necessery to fulfill these three actions
class Board
  attr_reader :data, :size

  def initialize(width, height, tokens_to_win = 3)
    @data = Array.new(height) { Array.new(width) }
    @tokens_to_win = tokens_to_win
  end

  def set_token(who, where)
    # TODO: Move validation to a different function
    return false if where > data.length * data[0].length || where <= 0

    # track on which element we are on
    cur_element_num = 1
    data.each_with_index do |row, y|
      row.each_with_index do |val, x|
        if where == cur_element_num
          return false unless val.nil?

          # Can only place if the value is nil, return true/false whether placed or not.
          data[y][x] = who
          return true
        end
        # checked one element time to update the count
        cur_element_num += 1
      end
    end
  end

  def tie?
    finished? and !victory?
  end

  def finished?
    data.flatten.none?(nil)
  end

  def victory?
    # When there are n consecutive tokens in any array on a data e.g. 3 X's in a row returns true
    rows = data
    if n_consec_tokens?(rows) ||
       n_consec_tokens?(columns)     ||
       n_consec_tokens?(l_diagonals) ||
       n_consec_tokens?(r_diagonals)
      true
    end
  end

  private

  attr_reader :tokens_to_win

  # Gets columns of the data
  def columns
    column = []
    arr_of_columns = []
    cur_col = 0
    while cur_col < data[0].length
      cur_row = 0
      while cur_row < data.length
        column << data[cur_row][cur_col]
        cur_row += 1
      end
      cur_col += 1
      arr_of_columns << column
      column = []
    end
    arr_of_columns
  end

  # Gets left or right diagonals of the data
  def l_diagonals(data = self.data)
    start_of_diagonal = 0
    diagonal = []
    arr_of_diagonals = []
    while start_of_diagonal < data[0].length
      cur_col = start_of_diagonal
      cur_row = 0
      while cur_row < data.length && cur_col < data[0].length
        diagonal << data[cur_row][cur_col]
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
    l_diagonals(data.reverse)
  end

  # True or false if there there are n tokens following each other,
  # in any given selection of tokens (2d array of columns, rows, diagonals of the data)
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
