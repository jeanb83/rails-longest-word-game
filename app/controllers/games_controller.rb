require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('a'..'z').to_a[rand(26)] }
  end

  def run_game(attempt, grid)
    # TODO: runs the game and return detailed hash of result
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    infos_word_serialized = open(url).read
    infos_word = JSON.parse(infos_word_serialized)
    english_word = infos_word["found"]
  end

  def in_grid?(attempt, grid)
    # TODO: check if the letters of the attempt are in the grid
    in_grid = []
    attempt.upcase.split('').each { |letter| in_grid.push(grid.include?(letter))}
    return in_grid
  end

  def h_freq_letters(array_letters)
    # TODO: puts an array of letters as a hash, with letter as key and its occurence as value
    frequency = {}
    array_letters.each do |letter|
      frequency[letter] += 1 if frequency.key?(letter)
      frequency[letter] = 1 if frequency.key?(letter) == false
    end
    return frequency
  end

  def overused?(grid, attempt)
    # TODO: compares the values (occurences) of 2 hashes (grid and attempt)
    # For each letter of the attempt, checks if it's in the grid
    # and if it's occurence is superior to the occurence of this letter in grid
    # then sets overused as true, else sets overused as false
    grid_freq = h_freq_letters(grid)
    attempt_letters = attempt.upcase.split('')
    attempt_freq = h_freq_letters(attempt_letters)
    overused = ""
    attempt_freq.each do |letter, _value|
      grid_freq.key?(letter) && attempt_freq[letter] > grid_freq[letter] ? overused = true : overused = false
    end
    return overused
  end

  def score
    @letters = params[:letters].split('')
    overused = overused?(@letters, params[:new])
    run_game = run_game(params[:new], @letters)
    in_grid = in_grid?(params[:new], @letters)
    if overused || in_grid.include?(false)
      @result = "Sorry but #{params[:new]} can't be built out of #{params[:letters]}"
    elsif run_game == false
      @result = "Sorry but #{params[:new]} doesn't seem to be a valid english word..."
    else @result = "Congratulations ! #{params[:new]} is a valid english word!"
    end
  end
end
