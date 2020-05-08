require "pry"

require_relative 'lib/game'
require_relative 'lib/board'

class Tui
  def run
    begin
      clear
      render_board
    end while prompt

    puts "WINNER: #{game.winner}"
  end

  private

  def clear
    puts "\e[H\e[2J"
  end

  def render_board
    puts game.board
      .map { |row| ([""] + row.map(&method(:piece_to_ascii)) + [""]).join(" | ") }
      .join("\n")
    puts
  end

  def prompt
    begin
      puts "#{game.player_turn}:"
      
      case game.action
      when :place
        puts "place at"

        xpos, ypos = gets.split(",")
        game.add_piece(xpos.to_i, ypos.to_i)

        true
      when :move
        puts "move piece"
        puts "  from: "
        from_x, from_y = gets.split(",")
        puts "  to: "
        to_x, to_y = gets.split(",")

        game.move_piece(from_x.to_i, from_y.to_i, to_x.to_i, to_y.to_i)

        true
      when :done
        puts "DONE"

        false
      end

    rescue Board::InvalidMove
      puts "Move not allowed"
      retry
    end
  end

  def game
    @game ||= Game.new(::Board.new)
  end

  def piece_to_ascii(piece)
    case piece
    when nil
      "-"
    when :black
      "b"
    when :white
      "w"
    end
  end
end

Tui.new.run
