# frozen_string_literal: true

# Manages how the data of the data ought to be displayed
# Generates an empty ASCII data of width*height squares
# Puts on the ASCII data appropriate symbols depending on the state of the data
# Prints the ASCII data with appropriate symbols onto the console
class Display
  def initialize(width, height)
    @circle = { [1, 4] => '0', [2, 3] => '0', [2, 6] => '0', [3, 5] => '0' }
    @cross = { [1, 3] => '#', [1, 7] => '#', [2, 5] => '#', [3, 3] => '#', [3, 7] => '#' }
    @display =  gen_canvas(width, height)
  end

  # Updates the ASCII display
  # Puts symbols (cross,circle)
  # In all the ASCCII squares where p1 or p2 has put their mark on the data
  def update(data)
    data.each_with_index do |row, nth_row|
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
    display.each do |row|
      row.each do |val|
        print val
      end
    end
  end

  #  private

  attr_reader :circle, :cross, :display

  def number_squares
    square_num = 1
    display.each_with_index do |row, i|
      row.each_with_index do |val, j|
        if (val == '|') && (display[i - 1][2] == '-') && (row[j + 1] != "\n")
          row[j + 1] = square_num
          square_num += 1
        end
      end
    end
  end

  # Puts given symbol (cross, circle) onto the ASCII display contained in an array
  def put_symbol(symbol, x, y)
    y_offset = 9 * y
    x_offset = 4 * x
    symbol.each do |k, v|
      display[k[0] + x_offset][k[1] + y_offset] = v
    end
  end

  # Generates the ASCII data array with the help of gen_vertical_lines and gen_horizontal line
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
