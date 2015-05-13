require 'io/console'
require 'set'

class HangmanGame
  def initialize(filename)
    @score = 0
    load_words(filename)
    load_pictures
  end

  def run
    running = true
    while running
      choose_word
      reset_hangman
      while alive? && !guessed?
        clear
        draw
        letter = prompt
        if letter == '!'
          running = false
          break
        end

        if @letters.include?(letter)

        elsif valid? letter
          add letter
          update letter
        else
          add letter
          hang
        end
        if guessed?
          score
        end
      end
      unless alive?
        break
      end
    end
    clear
    puts "The End"
    puts "Final score: #{@score}"
  end

  def load_words(filename)
    @words = [] # TODO
    File.open(filename).each do |line|
      @words << line
    end
end

  def load_pictures
    fp = File.open('hangman.txt')
    @num_stages = fp.readline.to_i
    stage_hight = fp.readline.to_i
    @stages = {}
    (0...@num_stages).each do |i| 
      @stages[i] = []
      (0...stage_hight).each do |j|
       cokolwiek = fp.readline
      @stages[i] << cokolwiek
    end
  end
  end

  def choose_word
    @correct_word = @words.sample
  end

  def reset_hangman
    @fails = 0
    @letters = Set.new
    @word = '_' * @correct_word.size
  end

  def alive?
    @fails < @num_stages - 1
  end

  def clear
    # STDOUT.write "\e[2J\e[1;1H"
  end 
  
  def goto(row, col)
    "\e[#{row};#{col}H"
  end

  def draw
    draw_gallows
    draw_letters
    draw_guess
    draw_score
  end

  def draw_gallows
    # TODO
    # narysuj szubienicę według bieżącego stanu gry
    @stages[@fails].each do |line|
      STDOUT.puts line
    end
  end

  def cols
    (ENV['COLUMNS'] || 80).to_i
  end

  def draw_letters
    STDOUT.puts @letters.to_a.join('')
    # TODO
    # wypisz użyte już litery po prawej stronie w wierszu 1
  end

  def draw_guess
    mid = (cols/2).to_i
    # TODO
    # wypisz obecny stan zgadywania na środku wiersza 2
    STDOUT.puts @word
  end

  def draw_score
    text = "Score: #{@score}"
  STDOUT.puts text
  end

  def prompt
    STDIN.getch
    # TODO
    # pobierz jeden znak z konsoli
  end

  def valid?(letter)
    # TODO
    # kiedy litera jest błędna?
    @correct_word.include?(letter)
  end

  def add(letter)
    # TODO
    @letters.add letter
  end

  def update(letter)
    start = -1
    while j = @correct_word.index(letter, start + 1)
      @word[j] = letter
      start = j
    end
  end

  def score
    @score += 1
  end

  def guessed?
    @word==@correct_word
  end

  def hang
    @fails += 1
  end
end

if $0 == __FILE__
  HangmanGame.new(ARGV[0]).run
end
