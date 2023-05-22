require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @grid = []
    10.times do
      @grid << ('A'..'Z').to_a.sample(1)
    end
    @grid.flatten!
  end

  def score
    @guess = params[:guess]
    @grid = params["token"]
    @url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    @user = JSON.parse(URI.open(@url).read)
    @found = @user['found']
    @word = @user['word'].upcase!
    @length = @user['length']
    @valid = @guess.chars.all? { |letter| @guess.length <= @grid.count(letter) }
    if @valid
      if @found
        @result = "Congratulations! #{@word} is a valid English word! YOUR SCORE IS: "
      else
        @result = "Sorry but #{@word} can't be built out of #{@grid}"
      end
    else
      @result = "Sorry but #{@word} does not seem to be a valid English word..."
    end
  end
end

# #####################################

# def generate_grid(grid_size)
#   # TODO: generate random grid of letters
#   Array.new(grid_size) { ('A'..'Z').to_a.sample }
# end

# def compute_score(attempt, time_taken)
#   time_taken > 60.0 ? 0 : (attempt.size * (1.0 - (time_taken / 60.0)))
# end

# def run_game(attempt, grid, start_time, end_time)
#   # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
#   result = { time: end_time - start_time }

#   score_and_message = score_and_message(attempt, grid, result[:time])
#   result[:score] = score_and_message.first
#   result[:message] = score_and_message.last

#   result
# end

# def score_and_message(attempt, grid, time)
#   if included?(attempt.upcase, grid)
#     if english_word?(attempt)
#       score = compute_score(attempt, time)
#       [score, "well done"]
#     else
#       [0, "not an english word"]
#     end
#   else
#     [0, "not in the grid"]
#   end
# end

# def english_word?(word)
#   response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
#   json = JSON.parse(response.read)
#   return json['found']
# end
