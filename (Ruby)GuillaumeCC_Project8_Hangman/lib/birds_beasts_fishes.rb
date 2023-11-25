# frozen_string_literal: true

require 'yaml'

# Methods that help drawing the current hangman state
module Hangman
  def hangman
    puts ' _____'
    puts ' |/  |'
    puts " |   #{'O' if @hangman >= 1}"
    puts " |  #{' |' if @hangman.between?(2, 3)}#{'\|' if @hangman == 4}#{'\|/' if @hangman >= 5}"
    puts " |   #{'|' if @hangman >= 3}"
    puts " |  #{'/' if @hangman == 6}#{'/ \\' if @hangman == 7}"
    puts ' |'
    puts '/|\______'
  end
end

# File save and load
module Files
  # >5 and <14 because the words include a newline character at the end
  def sample_word_list
    File.readlines('word_list.txt').select { |word| word.length > 5 && word.length < 14 }.sample.chomp.upcase.split('')
  end

  def save
    File.open('save_game.yml', 'w') { |file| file.write(YAML.dump(self)) }
    abort 'Game saved!'
  end

  def delete_file
    File.delete('save_game.yml')
  end

  def load_save_game
    game = YAML.load_file('save_game.yml')
    delete_file
    game.draw_hangman
    game.play
  end

  def save_game?
    return unless File.exist?('save_game.yml')

    puts 'Do you want to continue your saved game? (y/n)'
    if gets.chomp.downcase == 'y'
      load_save_game
    else
      delete_file
    end
  end
end

# Hangman game class
class Game
  include Files
  include Hangman

  def initialize
    save_game?
    @word = sample_word_list
    @board = Array.new(@word.length, '|_|')
    @available_letters = [*'A'..'Z']
    @turns = 1
    @hangman = 0
    play
  end

  def play
    play_turn
  end

  def draw_hangman
    hangman
    puts "#{7 - @hangman} lives left\n\n"
  end

  attr_reader :word, :board, :available_letters

  private

  def play_turn
    display_state
    evaluate(guess)
    draw_hangman
    @turns += 1
    play_turn
  end

  def display_state
    puts "Turn ##{@turns}. The word consists of #{@word.length} letters:\n"
    puts @board.join(' ')
    puts "\nThese are the remaining letters to chose from:\n#{@available_letters.join(' ')}\n\n"
    puts "Please enter your next guess (type 'exit' to save the game for later):"
  end

  def guess
    guessed_letter = gets.chomp.upcase
    if guessed_letter == 'EXIT'
      save
    elsif @available_letters.include?(guessed_letter)
      guessed_letter
    else
      puts 'Please type a letter that is still available:'
      guess
    end
  end

  def evaluate(guess)
    if word.include?(guess)
      puts "'#{guess}' is in the word!"
      word.each_index { |i| @board[i] = guess if word[i] == guess }
    else
      puts "'#{guess}' is not in the word"
      @hangman += 1
    end
    @available_letters[@available_letters.index(guess)] = '-'
    check_result
  end

  def check_result
    word = @word.join
    if @board == @word
      puts "You've guessed the word: #{word}"
      new_game
    elsif @hangman == 7
      draw_hangman
      puts "You've lost the game! The word was: #{word}"
      new_game
    end
  end

  def new_game
    puts 'Do you want to play a new game? (y/n)'
    new_game = gets.chomp.downcase
    if new_game == 'y'
      Game.new
    else
      puts "More information about this game:\n
        https://en.wikipedia.org/wiki/Hangman_(game)\n
        https://www.gutenberg.org/files/41727/41727-h/41727-h.htm#GameI_50\n\n"
      abort('Thanks for playing! Go learn some more names of birds, beasts and fishes! See you back soon!')
    end
  end
end

Game.new
