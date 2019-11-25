class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    @letters = Array.new(9) { ('A'..'Z').to_a.sample }
  end

  def score
    if attempt_in_grid? && attempt_in_english?
      @message = 'Well done!'
      @score = params['answer'].to_s.length
    elsif attempt_in_english?
      @message = 'Sorry, we don\'t know that word!'
      @score = 0
    else
      @message = 'That\'s not using the letters in the grid!'
      @score = 0
    end
  end

  def attempt_in_grid?
    answer = params['answer']
    attempt_arr = answer.upcase.split('')
    attempt_arr.all? { |letter| attempt_arr.count(letter) <= 9 }
  end

  def attempt_in_english?
    answer = params['answer']
    words_ser = open("https://wagon-dictionary.herokuapp.com/#{answer}")
    words = JSON.parse(words_ser.read)
    words['found'] == true
  end
end
