require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def letters
    ('a'..'z').to_a.sample(10)
  end

  def new
    @letters = letters
  end

  def score
    # The word can’t be built out of the original grid (letters are within the grid)
    def included?(word, grid)
      word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
    end

    # The word is valid according to the grid, but is not a valid English word
    def score_and_message(attempt, grid, time)
      if included?(attempt.upcase, grid)
        if english_word?(attempt)
          score = compute_score(attempt, time)
          [score, "well done"]
        else
          [0, "not an english word"]
        end
      else
        [0, "not in the grid"]
      end
    end

    # The word is valid according to the grid and is an English word
    def english_word?(word)
      response = URI.parse("https://wagon-dictionary.herokuapp.com/#{word}")
      json = JSON.parse(response.read)
      return json['found']
    end
  end
end
