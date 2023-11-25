module Moves

    # checks if a potential move is valid (i.e. on the board and available to move to that position)
    # checks to see if potential move is on the board
    # checks to see if potential move has a piece of the same colour in that spot
    def valid_move?(position, turn)

        if position == [] 
            return false
        end

        row = position[0]
        column = position[1]
        if row > 7 || row < 0 || column > 7 || column < 0
            return false
        else
            if turn == 1
                !@w_pieces.include?(board[row][column])
            else
                !@b_pieces.include?(board[row][column])
            end
        end
        
    end

    #returns all available positions that a piece can move
    def possible_moves(starting_position, actual_piece, turn = @turn, board = @board)
        row = starting_position[0]
        column = starting_position[1]
        potential_moves = []

        active_pieces = []
        enemy_pieces = []

        if turn == 1
            active_pieces = @w_pieces
            enemy_pieces = @b_pieces
        else
            active_pieces = @b_pieces
            enemy_pieces = @w_pieces
        end

        # moves available for white pawns
        if actual_piece == $w_pawn
            # if the white pawn is in its original spot, then it can move two spots or one spot
            return if row == 7

            if row == 1
                potential_moves << [row+1, column] if board[row+1][column] == ' '
                potential_moves << [row+2, column] if board[row+2][column] == ' '
            else
                potential_moves << [row+1, column] if board[row+1][column] == ' '
            end

            # can take black pieces, but only if they are available diagonally
            potential_moves << [row+1, column+1] if @b_pieces.include?(board[row+1][column+1])
            potential_moves << [row+1, column-1] if @b_pieces.include?(board[row+1][column-1])

            # can take black pawns under special en-passant rule
            if @en_passant_piece != []
                passant_row = invert_position_converter(@en_passant_piece)[0]
                passant_col = invert_position_converter(@en_passant_piece)[1]
                if passant_row == row && (passant_col == column + 1 || passant_col == column - 1)
                    # it must be empty in order for us to do en-passant (otherwise the pawn can just take)
                    if @board[passant_row+1][passant_col] = ' '
                        potential_moves << [passant_row+1, passant_col]
                    end
                end
            end
        end 

        # moves available for black pawns
        if actual_piece == $b_pawn
            # if the black pawn is in its original spot, then it can move two spots or one spot
            return if row == 0

            if row == 6
                potential_moves << [row-1, column] if board[row-1][column] == ' '
                potential_moves << [row-2, column] if board[row-2][column] == ' '
            else
                potential_moves << [row-1, column] if board[row-1][column] == ' '
            end

            # can take white pieces
            potential_moves << [row-1, column+1] if @b_pieces.include?(board[row-1][column+1])
            potential_moves << [row-1, column-1] if @b_pieces.include?(board[row-1][column-1])

            # can take white pawns under special en-passant rule

            if @en_passant_piece != []
                passant_row = invert_position_converter(@en_passant_piece)[0]
                passant_col = invert_position_converter(@en_passant_piece)[1]
                if passant_row == row && (passant_col == column + 1 || passant_col == column - 1)
                    if @board[passant_row-1][passant_col] = ' '
                        potential_moves << [passant_row-1, passant_col]
                    end
                end
            end
        end

        # moves available for rooks
        if actual_piece == $w_rook || actual_piece == $b_rook

            i_row = row
            i_col = column

            # returns all potential moves north of the starting position
            until i_row+1 == 8 || active_pieces.include?(board[i_row+1][i_col])
                if enemy_pieces.include?(board[i_row+1][i_col])
                    potential_moves << [i_row+1,i_col]
                    break
                else
                    potential_moves << [i_row+1,i_col]
                end
                i_row += 1
            end
            
            i_row = row
            i_col = column           

            # returns all potential moves south of the starting position
            until active_pieces.include?(board[i_row-1][i_col]) || i_row-1 == -1
                if enemy_pieces.include?(board[i_row-1][i_col])
                    potential_moves << [i_row-1,i_col]
                    break
                else
                    potential_moves << [i_row-1,i_col]
                end
                i_row -= 1
            end

            i_row = row
            i_col = column
            

            # returns all potential moves right of the starting position
            until active_pieces.include?(board[i_row][i_col+1]) || i_col+1 == 8
                if enemy_pieces.include?(board[i_row][i_col+1])
                    potential_moves << [i_row,i_col+1]
                    break
                else
                    potential_moves << [i_row,i_col+1]
                end
                i_col += 1
            end

            i_row = row
            i_col = column
                        
            # returns all potential moves left of the starting position
            until active_pieces.include?(board[i_row][i_col-1]) || i_col-1 == -1
                if enemy_pieces.include?(board[i_row][i_col-1])
                    potential_moves << [i_row,i_col-1]
                    break
                else
                    potential_moves << [i_row,i_col-1]
                end
                i_col -= 1
            end

            i_row = row
            i_col = column

        end

        # moves available for knights
        if actual_piece == $w_knig || actual_piece == $b_knig

            # returns all potential moves
            potential_moves << [row+2, column+1]
            potential_moves << [row+1, column+2]
            potential_moves << [row-1, column+2]
            potential_moves << [row-2, column+1]
            potential_moves << [row-2, column-1]
            potential_moves << [row-1, column-2]
            potential_moves << [row+1, column-2]
            potential_moves << [row+2, column-1]

        end

        # moves available for bishops
        if actual_piece == $w_bish || actual_piece == $b_bish

            i_row = row
            i_col = column

            # returns all potential moving north-east of the starting position

            until i_row+1 == 8 || i_col+1 == 8 || active_pieces.include?(board[i_row+1][i_col+1])
                if enemy_pieces.include?(board[i_row+1][i_col+1])
                    potential_moves << [i_row+1,i_col+1]
                    break
                else
                    potential_moves << [i_row+1,i_col+1]
                end
                i_row += 1
                i_col += 1
            end
            
            i_row = row
            i_col = column       

            # returns all potential moving south-east of the starting position
            until i_row-1 == -1 || i_col+1 ==8 || active_pieces.include?(board[i_row-1][i_col+1])
                if enemy_pieces.include?(board[i_row-1][i_col+1])
                    potential_moves << [i_row-1,i_col+1]
                    break
                else
                    potential_moves << [i_row-1,i_col+1]
                end
                i_row -= 1
                i_col += 1
            end
            
            i_row = row
            i_col = column       

            # returns all potential moving south-west of the starting position
            until i_row-1 == -1 || i_col-1 == -1 || active_pieces.include?(board[i_row-1][i_col-1])
                if enemy_pieces.include?(board[i_row-1][i_col-1])
                    potential_moves << [i_row-1,i_col-1]
                    break
                else
                    potential_moves << [i_row-1,i_col-1]
                end
                i_row -= 1
                i_col -= 1
            end
            
            i_row = row
            i_col = column      
            
            # returns all potential moving north-east of the starting position
            until  i_row+1 == 8 || i_col-1 == -1 || active_pieces.include?(board[i_row+1][i_col-1])
                if enemy_pieces.include?(board[i_row+1][i_col-1])
                    potential_moves << [i_row+1,i_col-1]
                    break
                else
                    potential_moves << [i_row+1,i_col-1]
                end
                i_row += 1
                i_col -= 1
            end
            
            i_row = row
            i_col = column  

        end

        # moves available for queens
        if actual_piece == $w_quee || actual_piece == $b_quee
            if actual_piece == $w_quee
                potential_moves.concat(possible_moves(starting_position, $w_rook, turn = 1))
                potential_moves.concat(possible_moves(starting_position, $w_bish, turn = 1))
            end
            if actual_piece == $b_quee
                potential_moves.concat(possible_moves(starting_position, $b_rook, turn = 2))
                potential_moves.concat(possible_moves(starting_position, $b_bish, turn = 2))
            end
        end

        # moves available for kings
        if actual_piece == $w_king || actual_piece == $b_king
            i_row = row
            i_col = column

            potential_moves << [i_row+1, i_col]
            potential_moves << [i_row+1, i_col+1]
            potential_moves << [i_row, i_col+1]
            potential_moves << [i_row-1, i_col-1]
            potential_moves << [i_row-1, i_col]
            potential_moves << [i_row-1, i_col+1]
            potential_moves << [i_row, i_col-1]
            potential_moves << [i_row+1, i_col-1]

            # castling conditions
            # The king does not move over a square that is attacked by an enemy piece during the castling move, i.e., when castling, there may not be an enemy piece that can move (in case of pawns: by diagonal movement) to a square that is moved over by the king.

            # The king cannot be in check if they are trying to castle
            if !@check_condition
                if actual_piece == $w_king
                    # checks for left rook potential
                    if board[0][1] == ' ' && board[0][2] == ' ' && board[0][3] == ' '
                        binding.pry
                        if @w_king_move == "not moved" && @w_rook_left == "not moved"
                            if !enemy_positions.include?([0, 3])
                                potential_moves << [0, 2]
                            end
                        end
                    #checks for right rook potential
                    elsif board[0][5] == ' ' && board[0][6] == ' '
                        if @w_king_move == "not moved" && @w_rook_right == "not moved"
                            if !enemy_positions.include?([0, 5])
                                potential_moves << [0, 6]
                            end
                        end
                    end
                end
                if actual_piece == $b_king
                    # checks for left rook potential
                    if board[7][1] == ' ' && board[7][2] == ' ' && board[7][3] == ' '
                        if @b_king_move == "not moved" && @b_rook_left == "not moved"
                            if !enemy_positions.include?([7, 3])
                                potential_moves << [7, 2]
                            end 
                        end
                    #checks for right rook potential
                    elsif board[7][5] == ' ' && board[7][6] == ' '
                        if @b_king_move == "not moved" && @b_rook_right == "not moved"
                            if !enemy_positions.include?([7, 5])
                                potential_moves << [7, 6] 
                            end
                        end
                    end
                end
            end

        end

        potential_moves = potential_moves.select { |pos| valid_move?(pos, turn)}

        potential_moves

    end

end