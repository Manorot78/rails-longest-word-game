require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }  # Génère 10 lettres aléatoires
  end

  def score
    @word = params[:word].upcase  # Le mot soumis par l'utilisateur en majuscules
    @letters = params[:letters].split  # Convertir la chaîne en tableau
    @included = word_in_grid?(@word, @letters)
    @valid = english_word?(@word)

    @message =
      if !@included
        "Le mot #{@word} ne peut pas être formé avec #{@letters.join(', ')}."
      elsif !@valid
        "#{@word} n'est pas un mot anglais valide."
      else
        "Bravo ! #{@word} est un mot valide 🎉"
      end
  end

  private

  # Vérifie si le mot peut être formé avec les lettres de la grille
  def word_in_grid?(word, letters)
    word.chars.all? { |char| word.count(char) <= letters.count(char) }
  end

  # Vérifie si le mot est un mot anglais valide via l'API
  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = JSON.parse(URI.open(url).read)
    response["found"]  # Retourne true si le mot existe, false sinon
  end
end
