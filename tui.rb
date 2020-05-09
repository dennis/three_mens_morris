# frozen_string_literal: true

require 'pry'

require_relative 'lib/game'
require_relative 'lib/board'

# Very crude UI for showing three men's morris
class Tui
  def run
    loop do
      clear
      render_board

      break unless prompt
    end

    puts "WINNER: #{game.winner}"
  end

  private

  def clear
    puts "\e[H\e[2J"
  end

  TEMPLATE = <<~STR
        0   1   2
      .-----------.
    0 |{0}|{1}|{2}|
      |---+---+---|
    1 |{3}|{4}|{5}|
      |---+---+---|
    2 |{6}|{7}|{8}|
      `---+---+---`
  STR

  PIECES = {
    nil => '   ',
    :black => ' b ',
    :white => ' w '
  }.freeze

  def render_board
    template = TEMPLATE

    (0...3).each do |xpos|
      (0...3).each do |ypos|
        template = render_board_cell(xpos, ypos, template)
      end
    end

    puts template
    puts
  end

  def render_board_cell(xpos, ypos, template)
    idx = ypos * 3 + xpos
    placeholder = "{#{idx}}"
    value = PIECES.fetch(game.piece_at(xpos, ypos))

    template.sub(placeholder, value)
  end

  def prompt
    puts "#{game.player_turn}:"

    send "handle_#{game.action}".to_sym
  rescue Board::InvalidMove
    puts 'Move not allowed'
    retry
  end

  def handle_place
    puts 'place at'

    xpos, ypos = gets.split(',').map(&:to_i)
    game.add_piece(xpos, ypos)

    true
  end

  def handle_move
    puts 'move piece from:'
    from_x, from_y = gets.split(',').map(&:to_i)

    puts "move piece from #{from_x},#{from_y} to:"
    to_x, to_y = gets.split(',').map(&:to_i)

    game.move_piece(from_x, from_y, to_x, to_y)

    true
  end

  def handle_done
    puts 'DONE'

    false
  end

  def game
    @game ||= Game.new(::Board.new)
  end
end

Tui.new.run
