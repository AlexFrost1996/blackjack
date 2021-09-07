require_relative 'user'

class Dealer < User
  def initialize
    super
    @name = 'Dealer'
  end

  def enough?
    hand.total_value >= 17
  end
end
