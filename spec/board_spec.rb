# frozen_string_literal: true

require_relative '../lib/board'

# rubocop:disable RSpec/ExampleLength
RSpec.describe Board do
  subject(:board) { described_class.new }

  context 'with a empty board' do
    it 'returns an array representing an empty board' do
      expect(board.to_a).to eq(
        [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, nil, nil]
        ]
      )
    end
  end

  context 'when adding pieces' do
    context 'when piece is placed on a vacant space' do
      it 'changes the board accordingly' do
        board.add_piece(1, 0, :white)

        expect(board.to_a).to eq(
          [
            [nil, :white, nil],
            [nil, nil, nil],
            [nil, nil, nil]
          ]
        )
      end
    end

    context 'when piece is placed on a non-vacant space' do
      it 'raises InvalidMove' do
        board.add_piece(1, 0, :white)

        expect { board.add_piece(1, 0, :white) }
          .to raise_error(Board::InvalidMove)
      end
    end

    context 'when piece is placed at -1, 0' do
      it 'raises InvalidMove' do
        expect { board.add_piece(-1, 0, :white) }
          .to raise_error(Board::InvalidMove)
      end
    end
  end

  context 'when moving a piece to an adjacent vacant space' do
    it 'changes the board accordingly' do
      board.add_piece(0, 0, :white)
      board.move_piece(0, 0, 1, 1)

      expect(board.to_a).to eq(
        [
          [nil, nil, nil],
          [nil, :white, nil],
          [nil, nil, nil]
        ]
      )
    end
  end

  context 'when moving a piece to an non-adjacent space' do
    it 'raises InvalidMove' do
      board.add_piece(0, 0, :white)

      expect { board.move_piece(0, 0, 2, 2) }
        .to raise_error(Board::InvalidMove)
    end
  end

  context 'when moving a piece to an adjacent non-vacant space' do
    it 'raises InvalidMove' do
      board.add_piece(0, 0, :white)
      board.add_piece(1, 1, :white)

      expect { board.move_piece(0, 0, 1, 1) }
        .to raise_error(Board::InvalidMove)
    end
  end

  context 'when moving empty space' do
    it 'raises InvalidMove' do
      expect { board.move_piece(0, 0, 1, 1) }
        .to raise_error(Board::InvalidMove)
    end
  end

  context 'when peeking at a space with an piece' do
    it 'returns the piece' do
      board.add_piece(0, 0, :white)

      expect(board.at(0, 0)).to eq(:white)
    end
  end

  context 'when moving to the same position as the piece were at' do
    it 'returns the piece' do
      board.add_piece(0, 0, :white)

      expect { board.move_piece(0, 0, 0, 0) }
        .to raise_error(Board::InvalidMove)
    end
  end

  context 'when peeking at a vacant space' do
    it 'returns the piece' do
      expect(board.at(0, 0)).to eq(nil)
    end
  end
end
# rubocop:enable RSpec/ExampleLength
