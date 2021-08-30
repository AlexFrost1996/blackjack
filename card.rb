class Card
  attr_accessor :value
  attr_reader :suit, :face

  def initialize(face, suit, value)
    @face = face
    @suit = suit
    @value = value
  end

  def show
    "#{face}#{suit}"
  end

  def hide
    '*'
  end
end
