# frozen_string_literal: true

# Contains the game state and controls the flow
class Game
  InvalidState = Class.new(RuntimeError)

  def initialize(board)
    @turns_taken = 0
    @board = board
    @hand_count = {
      white: 3,
      black: 3
    }
  end

  def hand_count(player)
    @hand_count.fetch(player)
  end

  def player_turn
    %i[white black][@turns_taken % 2]
  end

  def action
    if winner
      :done
    elsif hand_count(player_turn) == 0
      :move
    else
      :place
    end
  end

  def board
    @board.to_a
  end

  def add_piece(xpos, ypos)
    raise InvalidState unless action == :place

    take_turn do
      @board.add_piece(xpos, ypos, player_turn)
      @hand_count[player_turn] -= 1
    end
  end

  def move_piece(from_xpos, from_ypos, to_xpos, to_ypos)
    raise InvalidState unless action == :move

    take_turn do
      raise InvalidState unless @board.at(from_xpos, from_ypos) == player_turn

      @board.move_piece(from_xpos, from_ypos, to_xpos, to_ypos)
    end
  end

  def piece_at(xpos, ypos)
    @board.at(xpos, ypos)
  end

  def winner
    # horizontal
    a = check_winning_rows(@board.to_a)
    return a unless a.nil?

    # vertically
    a = check_winning_rows(@board.to_a.transpose)
    return a unless a.nil?

    # diagonally: from top left to bottom right
    a = check_winning_diagonal(@board.to_a)
    return a unless a.nil?
  end

  private

  def take_turn
    r = yield
    @turns_taken += 1
    r
  end

  def check_winning_rows(board)
    board.to_a.map(&:uniq).each do |row|
      return row[0] if row.length == 1 && !row[0].nil?
    end

    nil
  end

  def check_winning_diagonal(board) # rubocop:todo Metrics/AbcSize
    # top left -> bottom right
    diag = [board[0][0], board[1][1], board[2][2]].uniq
    return diag[0] if diag.length == 1

    # top right -> bottom left
    diag = [board[0][2], board[1][1], board[2][0]].uniq
    return diag[0] if diag.length == 1

    nil
  end
end
