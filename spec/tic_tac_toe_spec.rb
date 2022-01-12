# frozen_string_literal: true

RSpec.describe TicTacToe do
  it 'reads horizontal victory I' do
    board = [[1, 1, 1],
             [nil, nil, nil],
             [nil, nil, nil]]
    game = GameManager.new
    game.instance_variable_set(:@board, board)
    expect(game.board_state?).to eq('victory')
  end
  it 'reads horizontal victory II' do
    board = [[nil, nil, nil],
             [nil, nil, nil],
             [1, 1, 1]]
    game = GameManager.new
    game.instance_variable_set(:@board, board)
    expect(game.board_state?).to eq('victory')
  end
  it 'reads vertical victory I' do
    board = [[1, nil, nil],
             [1, nil, nil],
             [1, nil, nil]]
    game = GameManager.new
    game.instance_variable_set(:@board, board)
    expect(game.board_state?).to eq('victory')
  end
  it 'reads vertical victory II' do
    board = [[nil, nil, 1],
             [nil, nil, 1],
             [nil, nil, 1]]
    game = GameManager.new
    game.instance_variable_set(:@board, board)
    expect(game.board_state?).to eq('victory')
  end
  it 'reads diagonal victory I' do
    board = [[1, nil, nil],
             [nil, 1, nil],
             [nil, nil, 1]]
    game = GameManager.new
    game.instance_variable_set(:@board, board)
    expect(game.board_state?).to eq('victory')
  end
  it 'reads diagonal victory II' do
    board = [[nil, nil, 1],
             [nil, 1, nil],
             [1, nil, nil]]
    game = GameManager.new
    game.instance_variable_set(:@board, board)
    expect(game.board_state?).to eq('victory')
  end
  it 'reads tie' do
    board = [[0, 1, 1],
             [1, 0, 0],
             [1, 0, 1]]
    game = GameManager.new
    game.instance_variable_set(:@board, board)
    expect(game.board_state?).to eq('tie')
  end
  it 'reads tie II' do
    board = [[1, 1, 0],
             [0, 0, 1],
             [1, 1, 0]]
    game = GameManager.new
    game.instance_variable_set(:@board, board)
    expect(game.board_state?).to eq('tie')
  end
  it 'reads unfinished' do
    board = [[0, 1, nil],
             [1, nil, 1],
             [1, 1, 0]]
    game = GameManager.new
    game.instance_variable_set(:@board, board)
    expect(game.board_state?).to eq('unfinished')
  end
  it 'reads unfinished II' do
    board = [[0, 1, nil],
             [nil, nil, 1],
             [nil, 1, 0]]
    game = GameManager.new
    game.instance_variable_set(:@board, board)
    expect(game.board_state?).to eq('unfinished')
  end
end
