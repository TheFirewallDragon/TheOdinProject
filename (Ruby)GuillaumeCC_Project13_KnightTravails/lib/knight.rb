# frozen_string_literal: true

# Contains all possible moves of the knight piece
class Knight
  attr_accessor :x, :y

  def initialize
    @x = [1, 2, 1, -1, -2, -2, 2, -1]
    @y = [2, 1, -2, 2, -1, 1, -1, -2]
  end
end

