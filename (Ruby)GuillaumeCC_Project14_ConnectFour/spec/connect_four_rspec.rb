require_relative '../lib/connect_four'

describe Game do
  subject(:game_main) { described_class.new }

  describe '#initialize' do
    # Initialize -> No test necessary when only creating instance variables.
  end

  describe '#greeting_setup' do
    # method only prints to terminal and updates instance variables - no test necessary
  end

  describe '#print_board' do
    # method only prints to terminal - no test necessary
  end

  describe '#turn_message' do
    # method only prints to terminal - no test necessary
  end

  describe '#end_message' do
    # method only prints to terminal - no test necessary
  end

  describe '#draw_message' do
    # method only prints to terminal - no test necessary
  end

  describe '#make_selection' do
    context 'when invalid selections are made before a valid selection' do
      before do
        allow(game_main).to receive(:gets).and_return(8, 'a', 2)
      end

      it 'ends loop when valid selection is made' do
        initial_prompt = 'Choose a column, 1-7, to drop your piece into.'
        retry_prompt = 'Please choose a valid column to drop your piece.'
        expect(game_main).to receive(:puts).with(initial_prompt).once
        expect(game_main).to receive(:puts).with(retry_prompt).twice
        game_main.make_selection
      end
    end

    context 'when a valid selection is made' do
      before do
        allow(game_main).to receive(:gets).and_return(4)
      end

      it 'accepts 4' do
        prompt = 'Choose a column, 1-7, to drop your piece into.'
        expect(game_main).to receive(:puts).with(prompt).once
        result = game_main.make_selection
        expect(result).to eq(4)
      end
    end

    context 'when a valid edge selection is made' do
      before do
        allow(game_main).to receive(:gets).and_return(1)
      end

      it 'accepts 1' do
        prompt = 'Choose a column, 1-7, to drop your piece into.'
        expect(game_main).to receive(:puts).with(prompt).once
        result = game_main.make_selection
        expect(result).to eq(1)
      end
    end

    context 'when a column is full' do
      before do
        allow(game_main).to receive(:gets).and_return(1, 1, 2)
      end

      it 'does not accept the column as a valid selection' do
        array = [['x', ' ', ' ', ' ', ' ', ' ', ' '], ['x', ' ', ' ', ' ', ' ', ' ', ' '],
                 ['x', ' ', ' ', ' ', ' ', ' ', ' '], ['x', ' ', ' ', ' ', ' ', ' ', ' '],
                 ['x', ' ', ' ', ' ', ' ', ' ', ' '], ['x', ' ', ' ', ' ', ' ', ' ', ' ']]
        game_main.instance_variable_set(:@board_array, array)
        initial_prompt = 'Choose a column, 1-7, to drop your piece into.'
        retry_prompt = 'Please choose a valid column to drop your piece.'
        expect(game_main).to receive(:puts).with(initial_prompt).once
        expect(game_main).to receive(:puts).with(retry_prompt).twice
        game_main.make_selection
      end
    end
  end

  describe '#check_column' do
    context 'when a column is not full' do
      it 'returns false' do
        selection = 1
        result = game_main.check_column(selection)
        expect(result).to be false
      end
    end

    context 'when a column is full' do
      it 'returns true' do
        array = [['x', ' ', ' ', ' ', ' ', ' ', ' '], ['x', ' ', ' ', ' ', ' ', ' ', ' '],
                 ['x', ' ', ' ', ' ', ' ', ' ', ' '], ['x', ' ', ' ', ' ', ' ', ' ', ' '],
                 ['x', ' ', ' ', ' ', ' ', ' ', ' '], ['x', ' ', ' ', ' ', ' ', ' ', ' ']]
        game_main.instance_variable_set(:@board_array, array)
        selection = 1
        result = game_main.check_column(selection)
        expect(result).to be true
      end
    end
  end

  describe '#update_board' do
    context 'when a selection is made' do
      it 'updates the lowest space in the selected column' do
        new_array = [[' ', ' ', ' ', ' ', ' ', ' ', ' '], [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                     [' ', ' ', ' ', ' ', ' ', ' ', ' '], [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                     [' ', ' ', ' ', ' ', ' ', ' ', ' '], ['x', ' ', ' ', ' ', ' ', ' ', ' ']]
        selection = 1
        game_main.update_board(selection)
        expect(game_main.instance_variable_get(:@board_array)).to eq(new_array)
      end

      it 'updates the space with the appropriate player symbol' do
        new_array = [[' ', ' ', ' ', ' ', ' ', ' ', ' '], [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                     [' ', ' ', ' ', ' ', ' ', ' ', ' '], [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                     [' ', ' ', ' ', ' ', ' ', ' ', ' '], ['x', ' ', ' ', ' ', ' ', ' ', ' ']]
        selection = 1
        game_main.update_board(selection)
        expect(game_main.instance_variable_get(:@board_array)).to eq(new_array)
      end
    end
  end

  describe '#update_player_turn' do
    it 'changes the player_turn variable to the opposite player' do
      next_player = { name: 'cat', symbol: 'y' }
      game_main.update_player_turn
      expect(game_main.instance_variable_get(:@player_turn)).to eq(next_player)
    end
  end

  describe '#in_bounds?' do
    context 'when a position is within the confines of the board' do
      it 'returns true' do
        position = [1, 2]
        expect(game_main.in_bounds?(position)).to be true
      end
    end

    context 'when a position is outside the confines of the board' do
      it 'returns nil' do
        position = [-1, 9]
        expect(game_main.in_bounds?(position)).to be nil
      end
    end
  end

  describe '#check_draw' do
    it 'updates game_finished to true when there is a draw' do
      array = [['x', 'x', 'x', 'x', 'x', 'x', 'x'], ['x', 'x', 'x', 'x', 'x', 'x', 'x'],
               ['x', 'x', 'x', 'x', 'x', 'x', 'x'], ['x', 'x', 'x', 'x', 'x', 'x', 'x'],
               ['x', 'x', 'x', 'x', 'x', 'x', 'x'], ['x', 'x', 'x', 'x', 'x', 'x', 'x']]
      game_main.instance_variable_set(:@board_array, array)
      game_main.check_draw
      expect(game_main.instance_variable_get(:@game_finished)).to be true
    end

    it 'updates tie to true when there is a draw' do
      array = [['x', 'x', 'x', 'x', 'x', 'x', 'x'], ['x', 'x', 'x', 'x', 'x', 'x', 'x'],
               ['x', 'x', 'x', 'x', 'x', 'x', 'x'], ['x', 'x', 'x', 'x', 'x', 'x', 'x'],
               ['x', 'x', 'x', 'x', 'x', 'x', 'x'], ['x', 'x', 'x', 'x', 'x', 'x', 'x']]
      game_main.instance_variable_set(:@board_array, array)
      game_main.check_draw
      expect(game_main.instance_variable_get(:@tie)).to be true
    end

    it 'does not update game_finished when there is not a draw' do
      game_main.check_draw
      expect(game_main.instance_variable_get(:@game_finished)).to be false
    end

    it 'does not update tie when there is not a draw' do
      game_main.check_draw
      expect(game_main.instance_variable_get(:@game_finished)).to be false
    end
  end

  describe '#check_win' do
    context 'when a player wins' do
      it 'updates game_finished to true when a player wins vertically' do
        array = [[' ', ' ', ' ', ' ', ' ', ' ', ' '], [' ', 'y', ' ', ' ', ' ', ' ', ' '],
                 [' ', 'x', ' ', ' ', ' ', ' ', ' '], [' ', 'x', ' ', ' ', ' ', ' ', ' '],
                 [' ', 'x', ' ', ' ', ' ', ' ', ' '], [' ', 'x', ' ', ' ', ' ', ' ', ' ']]
        position = [2, 1]
        game_main.instance_variable_set(:@board_array, array)
        game_main.instance_variable_set(:@last_position, position)
        game_main.check_win(game_main.last_position.dup)
        expect(game_main.instance_variable_get(:@game_finished)).to be true
      end

      it 'updates game_finished to true when a player wins horizontally' do
        array = [[' ', ' ', ' ', ' ', ' ', ' ', ' '], [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                 [' ', ' ', ' ', ' ', ' ', ' ', ' '], [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                 [' ', ' ', ' ', ' ', ' ', ' ', ' '], ['y', 'x', 'x', 'x', 'x', ' ', ' ']]
        position = [5, 1]
        game_main.instance_variable_set(:@board_array, array)
        game_main.instance_variable_set(:@last_position, position)
        game_main.check_win(game_main.last_position.dup)
        expect(game_main.instance_variable_get(:@game_finished)).to be true
      end

      it 'updates game_finished to true when a player wins diagonally up' do
        array = [[' ', ' ', ' ', ' ', ' ', ' ', ' '], [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                 [' ', ' ', ' ', 'x', ' ', ' ', ' '], [' ', ' ', 'x', ' ', ' ', ' ', ' '],
                 [' ', 'x', ' ', ' ', ' ', ' ', ' '], ['x', ' ', ' ', ' ', ' ', ' ', ' ']]
        position = [3, 2]
        game_main.instance_variable_set(:@board_array, array)
        game_main.instance_variable_set(:@last_position, position)
        game_main.check_win(game_main.last_position.dup)
        expect(game_main.instance_variable_get(:@game_finished)).to be true
      end

      it 'updates game_finished to true when a player wins diagonally down' do
        array = [[' ', ' ', ' ', ' ', ' ', ' ', ' '], [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                 ['x', ' ', ' ', ' ', ' ', ' ', ' '], [' ', 'x', ' ', ' ', ' ', ' ', ' '],
                 [' ', ' ', 'x', ' ', ' ', ' ', ' '], [' ', ' ', ' ', 'x', ' ', ' ', ' ']]
        position = [5, 3]
        game_main.instance_variable_set(:@board_array, array)
        game_main.instance_variable_set(:@last_position, position)
        game_main.check_win(game_main.last_position.dup)
        expect(game_main.instance_variable_get(:@game_finished)).to be true
      end
    end

    context 'when a player does not win' do
      it 'does not update game_finished to true' do
        array = [[' ', ' ', ' ', ' ', ' ', ' ', ' '], [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                 [' ', ' ', ' ', ' ', ' ', ' ', ' '], [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                 [' ', ' ', ' ', ' ', ' ', ' ', ' '], ['x', ' ', 'x', ' ', 'x', ' ', 'x']]
        position = [2, 0]
        game_main.instance_variable_set(:@board_array, array)
        game_main.instance_variable_set(:@last_position, position)
        game_main.check_win(game_main.last_position.dup)
        expect(game_main.instance_variable_get(:@game_finished)).to be false
      end
    end
  end
end
