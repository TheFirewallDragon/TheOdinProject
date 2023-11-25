require 'stringio'
require './lib/chess'
require './lib/game_functions'
require './lib/moves'

describe 'check for check' do
    game = Game.new()

    it "checks to see if a check status is present" do

    game.board = [
        [$w_rook, $w_knig, $w_bish, $w_quee, $w_king, $w_bish, $w_knig, $w_rook],  
        [$w_pawn, $w_pawn, $w_pawn, $w_pawn, ' ', $w_pawn, $w_pawn, $w_pawn],                      
        [' ',' ',' ',$b_knig,' ',' ',' ',' '],
        [' ',' ',' ',' ',' ',' ',' ',' '],
        [' ',' ',' ',' ',' ',' ',' ',' '],
        [' ',' ',' ',' ',' ',' ',' ',' '],
        [$b_pawn, $b_pawn, $b_pawn, $b_pawn, $b_pawn, $b_pawn, $b_pawn, $b_pawn],
        [$b_rook, ' ', $b_bish, $b_quee, $b_king, $b_bish, $b_knig, $b_rook]
    ]

    expect(game.check_for_check).to be true
    end

end

describe "check for checkmate" do
    game = Game.new()

    it "checks to see if a checkmate status is present" do

    game.board = [
        [$w_rook, $w_knig, ' ', $w_king, ' ', $w_bish, $w_knig, $w_rook],  
        [$w_pawn, $w_pawn, $w_pawn, ' ', $w_pawn, $w_pawn, $w_pawn, $w_pawn],                      
        [' ',' ',' ',' ',' ',' ',' ',' '],
        [' ',' ',' ',$w_pawn,' ',$w_bish,' ',' '],
        [' ',' ',' ',$b_pawn,' ',' ',' ',' '],
        [' ',' ',' ',' ',' ',$b_knig,' ',' '],
        [$b_pawn, $b_pawn, $w_quee,' ', $b_pawn, $b_pawn, $b_pawn, $b_pawn],
        [$b_rook, $b_knig, $b_bish, $b_king, $b_quee, $b_bish,' ', $b_rook]
    ]

    game.turn = 2

    expect(game.check_for_checkmate).to be true
    end
end

describe "check for stalemate" do
    game = Game.new()

    it "checks to see if a stalemate status is present" do

    game.board = [
        [' ',' ',' ',' ',' ',' ',' ',' '],
        [' ',' ',' ',' ',' ',' ',' ',' '],
        [' ',' ',' ',' ',' ',' ',' ',' '],
        [' ',' ',' ',' ',' ',' ',' ',' '],
        [' ',' ',' ',' ',' ',' ',' ',' '],
        [' ',' ',' ',' ',' ',' ',' ',' '],
        [' ',' ',' ',$w_pawn,' ',' ',' ',' '],
        [' ',' ',' ',$b_king,' ',' ',' ',' ']
    ]
    
    game.print_board
    
    game.turn = 2

    expect(game.check_for_stalemate).to be true
    end
end

