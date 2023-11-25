module Board_Checks

    def print_board (board = @board)
        # need to add the a-h and 1 to 8 markings on the outside of these
        p [" ", "a", "b", "c", "d", "e", "f", "g", "h"]
        p ["8"].concat(board[7])
        p ["7"].concat(board[6])
        p ["6"].concat(board[5])
        p ["5"].concat(board[4])
        p ["4"].concat(board[3])
        p ["3"].concat(board[2])
        p ["2"].concat(board[1])
        p ["1"].concat(board[0])
    end

    # checks for remaining pieces that a player can move
    def remaining_pieces_check(turn = @turn)
        if turn == 1
            pieces = @board.flatten.uniq.select { |n| @w_pieces.include?(n)}
            pieces.map { |piece| @names_of_pieces[piece]}
        else
            pieces = @board.flatten.uniq.select { |n| @b_pieces.include?(n)}
            pieces.map { |piece| @names_of_pieces[piece]}
        end
    end

    def position_converter(position)
        row = position[0]
        column = position[1]
        letters = {
            0 => "a",
            1 => "b",
            2 => "c",
            3 => "d",
            4 => "e",
            5 => "f",
            6 => "g",
            7 => "h"
        }
        numbers = {
            0 => "1",
            1 => "2",
            2 => "3",
            3 => "4",
            4 => "5",
            5 => "6",
            6 => "7",
            7 => "8"
        }

        return letters[column] + numbers[row]
    end

    # takes in a string like B1 and converts it into a position on the board - in this case [1, 2]
    def invert_position_converter(letternumber)
        position = letternumber.split("")
        letters = {
            "a" => 0,
            "b" => 1,
            "c" => 2,
            "d" => 3,
            "e" => 4,
            "f" => 5,
            "g" => 6,
            "h" => 7
        }
        numbers = {
            "1" => 0,
            "2" => 1,
            "3" => 2,
            "4" => 3,
            "5" => 4,
            "6" => 5,
            "7" => 6,
            "8" => 7
        }

        # it gets converted back into row then column, which is number then letter first
        new_position = [numbers[position[1]], letters[position[0]]]
        position = new_position
        return position

    end

    # takes in a starting position, an ending position, and the piece to move
    def update_board(starting_position, ending_position, actual_piece, nboard)
        starting_row = starting_position[0]
        starting_col = starting_position[1]
        ending_row = ending_position[0]
        ending_col = ending_position[1]

        #en_passant situation
        if actual_piece == $w_pawn || actual_piece == $b_pawn
            if nboard[ending_row][ending_col] == ' '
                # if the piece selected is a pawn, the spot it is moving to is empty
                # and the ending column doesn't equal the starting column (i.e. it is moving diagonally), it is en-passant
                if ending_col != starting_col && @en_passant_piece != ''
                    en_passant_row = invert_position_converter(@en_passant_piece)[0]
                    en_passant_col = invert_position_converter(@en_passant_piece)[1]
                    @graveyard << nboard[en_passant_row][en_passant_col]
                    nboard[en_passant_row][en_passant_col] = ' '
                end
            end
        end

        #castling situation
        if actual_piece == $w_king || actual_piece == $b_king
            # castling must have occured in this situation
            if (ending_col - starting_col).abs == 2
                if actual_piece == $w_king && ending_col == 2
                    nboard[0][4] = ' '
                    nboard[0][2] = $w_king
                    nboard[0][0] = ' '
                    nboard[0][3] = $w_rook
                elsif actual_piece == $w_king && ending_col == 6
                    nboard[0][4] = ' '
                    nboard[0][6] = $w_king
                    nboard[0][7] = ' '
                    nboard[0][5] = $w_rook
                elsif actual_piece == $b_king && ending_col == 2
                    nboard[7][4] = ' '
                    nboard[7][2] = $b_king
                    nboard[7][0] = ' '
                    nboard[7][3] = $b_rook
                elsif actual_piece == $b_king && ending_col == 6
                    nboard[7][4] = ' '
                    nboard[7][6] = $b_king
                    nboard[7][7] = ' '
                    nboard[7][5] = $b_rook
                end
            end
        end
        
        if nboard[ending_row][ending_col] != ' '
            @graveyard << nboard[ending_row][ending_col]
        end

        nboard[ending_row][ending_col] = actual_piece
        nboard[starting_row][starting_col] = ' '

        nboard

    end

    # returns in the position(s) of the selected piece
    def find_position(piece)
        row = 0
        col = 0
        results = []

        until row == 8
            until col == 8
                if @board[row][col] == piece
                    results << [row, col]
                end
                col +=1
            end
            row +=1
            col = 0
        end

        return results

    end

    # checks for a "check" condition
    def check_for_check(board = @board, turn = @turn)
        # how do we determine if a check is in place?
        # if on the next turn, an enemy piece can take the king, then there is a check right now
        # we have to look at every enemy piece and their potential move and see if one of those moves falls on the position of the current king
        # first, we generate a nested array of all enemy pieces and their starting positions in form [enemy_piece, starting_position]
        # then, we generate an array of all potential moves that these enemy pieces can make

        enemy_pieces = []
        enemy_filtered_board = [] #filtered board that only includes enemy pieces
        enemy_ending_positions = [] #array that contains all available moves for enemy pieces
        enemy_turn = []

        active_filtered_board = []
        active_ending_positions = []
        active_pieces = []
        active_turn = []

        status = ""

        if turn == 1
            enemy_pieces = @b_pieces
            active_pieces = @w_pieces
            enemy_turn = 2
        else
            enemy_pieces = @w_pieces
            active_pieces = @b_pieces
            enemy_turn = 1
        end

        # goes through the board and looks for enemy pieces
        # add the actual enemy piece and the position of the enemy piece to the enemy_filtered_board array
        row = 0
        column = 0
        until row == 8
            column = 0
            until column == 8
                if enemy_pieces.include?(@board[row][column])
                    enemy_filtered_board << [@board[row][column], [row, column]]
                end
                column += 1
            end
            row += 1
        end

        # creates an array of positions that enemy pieces can move in the next turn
        enemy_filtered_board.each do |pieceandposition|
            piece = pieceandposition[0]
            position = pieceandposition[1]
            enemy_ending_positions << possible_moves(position, piece, enemy_turn, board)
            enemy_ending_positions.flatten
        end

        enemy_ending_positions = enemy_ending_positions.flatten(1)

        # checks to see if the king is currently in check
        if turn == 1 && enemy_ending_positions.include?(find_position($w_king)[0])
            status = true
        elsif turn == 2 && enemy_ending_positions.include?(find_position($b_king)[0])
            status = true
        else
            status = false
        end

        # returns true or false based on whether or not a check is present
        status

    end

    def find_enemy_ending_position(board = @board)
        enemy_pieces = []
        enemy_filtered_board = [] #filtered board that only includes enemy pieces
        enemy_ending_positions = [] #array that contains all available moves for enemy pieces
        enemy_turn = []

        active_filtered_board = []
        active_ending_positions = []
        active_pieces = []
        active_turn = []

        if turn == 1
            enemy_pieces = @b_pieces
            active_pieces = @w_pieces
            enemy_turn = 2
        else
            enemy_pieces = @w_pieces
            active_pieces = @b_pieces
            enemy_turn = 1
        end

        # goes through the board and looks for enemy pieces
        # add the actual enemy piece and the position of the enemy piece to the enemy_filtered_board array
        row = 0
        column = 0
        until row == 8
            column = 0
            until column == 8
                if enemy_pieces.include?(board[row][column])
                    enemy_filtered_board << [board[row][column], [row, column]]
                end
                column += 1
            end
            row += 1
        end

        # creates an array of positions that enemy pieces can move in the next turn
        enemy_filtered_board.each do |pieceandposition|
            piece = pieceandposition[0]
            position = pieceandposition[1]
            enemy_ending_positions << possible_moves(position, piece, enemy_turn, board)
            enemy_ending_positions.flatten
        end

        enemy_ending_positions = enemy_ending_positions.flatten(1)
        
        enemy_ending_positions

    end

    # this function is only called when a check is already present
    # therefore, we only need to look to see if there are solutions for removing the check condition
    def check_for_checkmate

        statuses = []
        active_filtered_board = []
        active_pieces = []

        if turn == 1
            active_pieces = w_pieces
        else
            active_pieces = b_pieces
        end

        # returns an array of the board filtered for only active pieces
        row = 0
        until row == 8
            column = 0
            until column == 8
                if active_pieces.include?(board[row][column])
                    active_filtered_board << [board[row][column], [row, column]]
                end
                column += 1
            end
            row += 1
        end

        # for each active piece, first make an array of each possible ending move
        # for each possible move, play out a scenario where that move is made and then check to see if a "check" is still in place
        # if a check is still in place then add the "statuses" array a "check" string
        # if a check is no long in place, then add to the "statuses" array a "safe" string

        active_filtered_board.each do |pieceandposition|
            piece = pieceandposition[0]
            starting_pos = pieceandposition[1]
            test_board = @board.dup.map(&:dup)
            possible_moves = possible_moves(pieceandposition[1], pieceandposition[0], turn, board)
            possible_moves.each do |ending_move|
                test_board = update_board(starting_pos, ending_move, piece, test_board)
                if check_for_check(test_board)
                    statuses << "check"
                else
                    statuses << "safe"
                end
            end
        end

        active_filtered_board = active_filtered_board.flatten(1)

        # if there is a "safe" element at all, then the king is not in "checkmate"
        if statuses.include?("safe")
            return false
        else
            return true
        end

    end

    def check_for_stalemate
        statuses = []
        active_filtered_board = []
        active_pieces = []

        if @turn == 1
            active_pieces = @w_pieces
        else
            active_pieces = @b_pieces
        end

        # returns an array of the board filtered for only active pieces
        row = 0
        until row == 8
            column = 0
            until column == 8
                if active_pieces.include?(@board[row][column])
                    active_filtered_board << [@board[row][column], [row, column]]
                end
                column += 1
            end
            row += 1
        end

        active_filtered_board.each do |pieceandposition|
            piece = pieceandposition[0]
            starting_pos = pieceandposition[1]
            test_board = @board.dup.map(&:dup)
            possible_moves = possible_moves(pieceandposition[1], pieceandposition[0], @turn, test_board)
            possible_moves.each do |ending_move|
                new_board = update_board(starting_pos, ending_move, piece, test_board.dup.map(&:dup))
                if check_for_check(new_board)
                    statuses << "check"
                else
                    statuses << "safe"
                end
            end
        end

        active_filtered_board = active_filtered_board.flatten(1)

        if !statuses.include?("safe")
            return true
        else
            return false
        end

    end

end