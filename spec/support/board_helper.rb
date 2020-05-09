# frozen_string_literal: true

module BoardHelper
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  # helper - visualize a board
  def stringify_board(board)
    board.map do |r1|
      r1.map do |r2|
        case r2
        when :black
          'b'
        when :white
          'w'
        else
          '-'
        end
      end.join
    end.join("\n") + "\n"
  end

  # helper - make it a bit easier to build board as we can 'draw' it
  def populate_board(_board, str)
    black = []
    white = []

    # parse string
    str.delete("\n").split(//).each.with_index do |space, idx|
      xpos = idx % 3
      ypos = (idx - xpos) / 3

      case space
      when 'w'
        white << [xpos, ypos]
      when 'b'
        black << [xpos, ypos]
      end
    end

    # populate
    loop do
      pos =
        if game.player_turn == :white
          white.shift
        else
          black.shift
        end

      game.add_piece(*pos)

      break if white.empty? && black.empty?
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
