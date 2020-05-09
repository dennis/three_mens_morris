# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative 'support/board_helper'

# rubocop:disable RSpec/ExampleLength
RSpec.describe Game do
  include BoardHelper

  subject(:game) { described_class.new(board) }

  let(:board) { Board.new }

  context 'with a new game' do
    it 'white player got 3 pieces on hand' do
      expect(game.hand_count(:white)).to eq(3)
    end

    it 'black player got 3 pieces on hand' do
      expect(game.hand_count(:black)).to eq(3)
    end

    it "is :white's turn" do
      expect(game.player_turn).to eq(:white)
    end

    it 'expects white to place a piece' do
      expect(game.action).to eq(:place)
    end

    it 'renders an empty board' do
      expect(stringify_board(game.board)).to eq(<<~STR)
        ---
        ---
        ---
      STR
    end
  end

  context 'when placing the initial piece' do
    before { game.add_piece(1, 1) }

    it 'sets white first' do
      expect(stringify_board(game.board)).to eq(<<~STR)
        ---
        -w-
        ---
      STR
    end

    it 'reduces white hand_count' do
      expect(game.hand_count(:white)).to eq(2)
    end

    it 'does not change black hand_count' do
      expect(game.hand_count(:black)).to eq(3)
    end

    it "is :black's turn" do
      expect(game.player_turn).to eq(:black)
    end

    it 'adds black and then white as next pieces' do
      game.add_piece(0, 0)
      game.add_piece(2, 2)

      expect(stringify_board(game.board)).to eq(<<~STR)
        b--
        -w-
        --w
      STR
    end

    it 'disallows players to move a piece' do
      populate_board(game.board, <<~STR)
        wb-
        ---
        ---
      STR

      expect { game.move_piece(0, 0, 1, 1) }.to raise_error Game::InvalidState
    end

    it 'returns the piece at 1,1' do
      expect(game.piece_at(1, 1)).to eq(:white)
    end

    it 'returns nil as there is no piece at 2,2' do
      expect(game.piece_at(2, 2)).to eq(nil)
    end
  end

  context 'when all pieces are placed on board' do
    before do
      populate_board(game.board, <<~STR)
        -wb
        w-b
        -bw
      STR
    end

    it "is :white's turn" do
      expect(game.player_turn).to eq(:white)
    end

    it 'reports no pieces for white' do
      expect(game.hand_count(:white)).to eq(0)
    end

    it 'reports no pieces for black' do
      expect(game.hand_count(:black)).to eq(0)
    end

    it 'returns move as next action' do
      expect(game.action).to eq(:move)
    end

    it 'allows player to move a piece' do
      game.move_piece(1, 0, 1, 1)

      expect(stringify_board(game.board)).to eq(<<~STR)
        --b
        wwb
        -bw
      STR
    end

    it 'disallows adding pieces' do
      expect { game.add_piece(1, 1) }.to raise_error Game::InvalidState
    end
  end

  context 'when game is won horizontal' do
    before do
      populate_board(game.board, <<~STR)
        ww-
        bbb
        -w-
      STR
    end

    it 'returns done' do
      expect(game.action).to eq(:done)
    end

    it 'returns black as winner' do
      expect(game.winner).to eq(:black)
    end
  end

  context 'when game is won vertically' do
    before do
      populate_board(game.board, <<~STR)
        wb-
        wbw
        -b-
      STR
    end

    it 'returns done' do
      expect(game.action).to eq(:done)
    end

    it 'returns black as winner' do
      expect(game.winner).to eq(:black)
    end
  end

  context 'when game is won diagonally' do
    before do
      populate_board(game.board, <<~STR)
        w-b
        wbw
        b--
      STR
    end

    it 'returns done' do
      expect(game.action).to eq(:done)
    end

    it 'returns black as winner' do
      expect(game.winner).to eq(:black)
    end
  end

  context 'when game is won diagonally (other direction)' do
    before do
      populate_board(game.board, <<~STR)
        b-w
        wbw
        --b
      STR
    end

    it 'returns done' do
      expect(game.action).to eq(:done)
    end

    it 'returns black as winner' do
      expect(game.winner).to eq(:black)
    end
  end
end
# rubocop:enable RSpec/ExampleLength
