require 'yaml'

class Hangman
  attr_accessor :solution, :misses, :board
  
  def initialize
    @solution = get_word
    @misses = []
    @guess_board = []
    (@solution.length).times {@guess_board << "_"}
  end
  
  def play
    intro
    load_game?
    while true
      turn
    end
    game_over
  end
  
  def intro
    puts "_"*25
    puts "   Welcome to Hangman!"
    puts "-"*25
    puts "The object of this game"
    puts "is to guess a random word"
    puts "between 5 & 12 characters,"
    puts "one letter at a time."
    puts "after 6 wrong guesses you"
    puts "lose, so tread lightly!"
    puts "enter 'load' to load a saved game, or"
    puts "any other key to start a new game!"
  end
  
  def load_game?
      if gets.chomp == 'load'
        data = YAML.load(File.read('save.yml'))
        @solution = data[0]
        @guess_board = data[1]
        @misses = data[2]
      end
  end
  
  def get_word
    File.readlines("data/5desk.txt").select {|w| w.size >= 5 && w.size <= 12}.sample.downcase.delete!("\n")
  end
  
  def game_over
    puts 'Game over!'
  end
  
  def turn
    draw_board
    guess = get_input
    check_input(guess)
    game_over?
  end
  
  def draw_board
    system "clear"
    #visual representation with ASCII?
    puts @guess_board.join(" ")
    puts "incorrect guesses: #{@misses.inspect}"
  end
  
  def get_input
    puts "Guess a letter a-z, or type"
    puts "'save' to save your game."
    input = gets.chomp
      if input == 'save'
        save_game
      else 
        input.downcase[0]
      end
  end
  
  def check_input(guess)
    hit = false
    @solution.split("").each_with_index do |q,i|
      if q == guess
        @guess_board[i] = guess
        hit = true
      end
    end
    @misses << guess if hit == false
  end
  
  def save_game
    data = [@solution, @guess_board, @misses]
    File.open("save.yml", "w"){|q| q.write(YAML.dump(data))}
    exit
  end
  
  def game_over?
    win if @guess_board.join == @solution
    lose if @misses.length >= 6
  end
  
  def win
    draw_board
    puts "You win!"
    play_again?
  end
  
  def lose
    puts "You lose! Correct answer was: #{@solution}"
    play_again?
  end
  
  def play_again?
    puts "Play again? Type 'y' to start a new game!"
    input = gets.chomp
    if input == 'y'
      game = Hangman.new
      game.play
    else
      puts "Goodbye!"
      exit
    end
  end
end

game = Hangman.new
game.play