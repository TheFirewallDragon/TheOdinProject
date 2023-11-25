# frozen_string_literal: true

require_relative 'lib/knight'
require_relative 'lib/board'

k = Board.new

k.knight_moves([3,3], [4,3])