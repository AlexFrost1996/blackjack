# frozen_string_literal: true

require_relative 'card'

class Deck
  FACES = [*(2..10), 'J', 'Q', 'K', 'A'].freeze
  SUITS = ['♥', '♠', '♣', '♦'].freeze

  def initialize
    @deck = []
    deck
    @deck.shuffle!.reverse!.shuffle!
  end

  def deal(quantity = 1)
    @deck.pop(quantity)
  end

  private

  def deck
    FACES.each do |face|
      value = case face
              when Integer
                face
              when 'A'
                11
              else
                10
              end
      SUITS.each do |suit|
        @deck << Card.new(face, suit, value)
      end
    end
  end
end
