class PlayingController < ApplicationController
  require 'open-uri'
  require 'json'
  require 'time'

  def game
    # 9.times do
    #   if
    #     choose_vowel
    #   else
    #     choose_consonant
    #   end
    # end
    @grid = generate_grid
    @start_time = Time.now
    @score = params[:score]
  end

  def score
    @grid = params[:grid].delete('\\"').split("")
    @attempt = params[:attempt]
    @start_time = params[:start_time]
    @score = params[:score]
    end_time = Time.now
    time_taken = end_time - Time.parse(@start_time)
    if included?(@attempt.upcase, @grid)
      if get_translation(@attempt)
        @score = @score.to_i + compute_score(@attempt, time_taken)
        @message = "Well done!"
      else
        @score = @score.to_i
        @message = "This word is not an english one..."
      end
    else
      @score = @score.to_i
      @message = "The word is not in the grid..."
    end
  end

  private

  def generate_grid
    Array.new(9) { ('A'..'Z').to_a[rand(26)] }
  end

  def included?(guess, grid)
    the_grid = grid.clone
    guess.chars.each do |letter|
      the_grid.delete_at(the_grid.index(letter)) if the_grid.include?(letter)
    end
    grid.size == guess.size + the_grid.size
  end

  def compute_score(attempt, time_taken)
    (time_taken > 60.0) ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def get_translation(word)
    response = open("http://api.wordreference.com/0.8/80143/json/enfr/#{word.downcase}")
    json = JSON.parse(response.read.to_s)
    json['term0']['PrincipalTranslations']['0']['FirstTranslation']['term'] unless json["Error"]
  end

  # def choose_vowel
  #   ['A', 'E', 'I', 'O', 'U', 'Y'][rand(6)]
  # end

  # def choose_consonant
  #   ['B', 'C', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X', 'Z'][rand(20)]
  # end

end
