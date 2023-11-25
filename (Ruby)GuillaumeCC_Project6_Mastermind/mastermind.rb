class PlayerSelect
  def self.maker
    input = ""
    until input == "1" || input == "2"
        puts "\n  Welcome to Mastermind!"
        puts "  ---"
        puts "  Are you a code breaker or a code maker?"
        puts "  Enter '1' to break the code or '2' to make the code:"    
        input = gets.chomp
    end
    input == "1" ? @maker = "computer" : @maker = "player"
  end
end

class CodeSelect
  def self.code(maker)
    @code = []
    if maker == "player"
      puts "\n  So you think you can outsmart a computer, eh? "
      until @code.length == 4
        puts "  Please make a 4-digit code containing only 1 - 6."
        code_string = gets.chomp
        if !code_string.include?("7") && !code_string.include?("8") && !code_string.include?("9") && !code_string.include?("0") && code_string.length == 4 && code_string.to_i > 0 && code_string.to_i >= 1111
          @code = code_string.split("")
          i = 0
          until i >= @code.length
            @code[i] = @code[i].to_i
            i += 1
          end
        else
          puts "  Please try again."
        end
        puts "\n  Your secret code is #{@code}."
      end
    elsif maker == "computer"
      i = 0
      while i <= 3 do
        @code[i] = 1 + Random.rand(6)
        i += 1
      end
    end
    return @code
  end
end

class CheckCode
  def self.results(secret_code, guess_code)
    @secret_code = secret_code
    @guess_code = guess_code
    @results = ""

    i = 0
    while i < @secret_code.length
      if @guess_code[i] == @secret_code[i]
        # Add 1 correct "number in position" marker
        @results << "O"                                     # Symbol for correct number, correct position
      elsif @secret_code[i] == @guess_code[0] || @guess_code[1] || @guess_code[2] || @guess_code[3]
        # Add 1 correct number in wrong position marker
        @results << "X"                                         # Symbol for correct number, wrong position
      end
      i += 1
    end
    return @results
  end
end

class DisplayResults
  def self.display(secret_code, guess)
    @code = Marshal.load(Marshal.dump(secret_code))
    @guess = Marshal.load(Marshal.dump(guess))
    @results = ""

    i = 0
    while i < @code.length
      if @code[i] == @guess[i]
        # Add 1 correct "number in position" marker
        @results << "O"                                     # Symbol for correct number, correct position
        # Remove both from the array
        @code.delete_at(i)
        @guess.delete_at(i)
      else
        i += 1
      end
    end
    # Check for correct numbers
    diff = @code - @guess
    diff = @code - diff
    j = 0
    while j < diff.length
      @results << "X"                                       # Symbol for correct number, wrong position
      j += 1
    end
    return @results
  end
end

class GamePlayLoop
  def initialize(maker)
    if maker == "computer"
      PlayerGuessLoop.loop(maker)
    elsif maker == "player"
      ComputerGuessLoop.loop(maker)
    end
    puts "  Would you like to play again?"
    again = ""
    until again == "Y" || again == "N"
        puts "  Enter 'Y' to play again or 'N' give up:"
        again = gets.chomp.upcase
    end
    again == "Y" ? game = GamePlayLoop.new(PlayerSelect.maker) : @maker = "player"
  end
end

class ArrayOfPossibilities
  def self.create_array
    # Make my Array of Arrays
    array_of_possibilities = Array.new(4)
    i = 0
    array0 = 1
    array1 = 1
    array2 = 1
    array3 = 1
    
    until array0 > 6 
      until array1 > 6
        until array2 > 6
          until array3 > 6
            array_of_possibilities[i] = [array0, array1, array2, array3]
            i += 1
            array3 += 1
          end
          array3 = 1
          array2 +=1
        end
        array2 = 1
        array1 +=1
      end
      array1 = 1
      array0 +=1
    end
    return array_of_possibilities
  end
end

class PlayerGuessLoop
  def self.loop(maker)
    attempt = 1
    code = CodeSelect.code(maker)
    send_code = code.clone
    puts "\n  After each guess, you will be given clues about the code:"
    puts "    Each 'O' means that you have 1 correct number in the correct position"
    puts "    Each 'X' means that you have 1 correct number in the wrong position"
    puts "\n  You have 12 attempts to find the secret code, do you have what it takes?\n"
    while attempt <= 12
      puts "\n  Attempt ##{attempt}: What do you think the 4 digit password is?"
      @guess = PlayerValidGuess.valid
      send_guess = @guess
      send_code = code
      results = DisplayResults.display(send_code, send_guess)

      #print guess with results and increment attempt
      PrintResults.print(@guess, results, attempt)
      GameOverCheck.check(maker, results, attempt)
      attempt += 1
    end
  end
end

class PlayerValidGuess
  def self.valid
    guess = gets.chomp
    until guess.length == 4 && guess.to_i > 0 && !guess.include?("7") && !guess.include?("8") && !guess.include?("9") && !guess.include?("0")
      puts "Don't forget the parameters of the code!"
      guess = gets.chomp
    end
    guess = guess.split("")
    i = 0
    while i < 4
      guess[i] = guess[i].to_i
      i += 1
    end
    return guess
  end
end

class ComputerGuessLoop
  def self.loop(maker)
    attempt = 1
    code = CodeSelect.code(maker)
    array_of_possibilities = ArrayOfPossibilities.create_array()

    while attempt <= 12
      if attempt == 1
        @guess = [1, 1, 2, 2]
      else
        @guess = array_of_possibilities[0]
      end

      results = DisplayResults.display(code, @guess)
      sleep(1)
      PrintResults.print(@guess, results, attempt)
      
      GameOverCheck.check(maker, results, attempt) ? break :      
      results = CheckCode.results(code, @guess)

      i = array_of_possibilities.length - 1
      until i < 0
        send_possibility = array_of_possibilities[i]
        possible_results = CheckCode.results(@guess, send_possibility)
        unless results == possible_results
          array_of_possibilities.delete_at(i)
        end
        i -= 1
      end
      attempt += 1
    end
  end
end

class PrintResults
  def self.print(guess, results, attempt)
    puts "\n  #{guess}" 
    puts "              Clues: " + results + "\n"
    puts "  Guesses remaining: #{12 - attempt} \n"
  end
end

class GameOverCheck
  def self.check(maker, results, attempt)
    if results == "OOOO"
      if maker == "computer"
        puts "You figured out the code in #{attempt} guesses."
      elsif maker == "player"
        puts "\n  The computer deciphered your code in #{attempt} guesses. Better luck next time.\n\n"
      end 
      return true
    elsif attempt == 12
      puts "\n  Good effort, but the secret code is now lost forever. Better luck next time.\n\n"
      return true
    else 
      return false
    end
  end
end

game = GamePlayLoop.new(PlayerSelect.maker)