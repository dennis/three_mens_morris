# frozen_string_literal: true

# This class is the board itself. It handles boundary check, placement, movement
# but does not care about what game is played on it
class Board
  InvalidMove = Class.new(RuntimeError)

  def initialize
    @spaces = Array.new(9)
  end

  def to_a
    @spaces.each_slice(3).to_a
  end

  def add_piece(xpos, ypos, piece)
    raise InvalidMove unless @spaces[pos_to_idx(xpos, ypos)].nil?

    @spaces[ypos * 3 + xpos] = piece
  end

  def move_piece(from_xpos, from_ypos, to_xpos, to_ypos) # rubocop:todo Metrics/AbcSize
    from_idx = pos_to_idx(from_xpos, from_ypos)
    to_idx = pos_to_idx(to_xpos, to_ypos)

    # Calcuate distance. We're only allowed to move to an adjacent space
    dist = [(from_xpos - to_xpos).abs, (from_ypos - to_ypos).abs].max
    raise InvalidMove if dist > 1

    piece = @spaces[from_idx]

    raise InvalidMove if piece.nil?
    raise InvalidMove unless @spaces[to_idx].nil?

    @spaces[from_idx] = nil
    @spaces[to_idx] = piece
  end

  def at(xpos, ypos)
    @spaces[pos_to_idx(xpos, ypos)]
  end

  private

  def pos_to_idx(xpos, ypos)
    raise InvalidMove if xpos < 0 || xpos > 2
    raise InvalidMove if ypos < 0 || ypos > 2

    ypos * 3 + xpos
  end
end
