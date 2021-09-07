require_relative 'hand'

class User
  attr_reader :name
  attr_writer :pass
  attr_accessor :hand, :bankroll

  BET = 10

  def initialize(name = 'Player')
    @name = name
    @bankroll = 100
    @hand = Hand.new
    @pass = false
  end

  def bet(bet_size = BET)
    bankroupt!
    self.bankroll -= bet_size
    bet_size
  end

  def pass?
    @pass
  end

  def take_card(card)
    hand.take_card(card)
  end

  private

  def bankroupt!
    raise "GAME OVER! No money, you bankroupt!" if bankroll.zero?
  end
end
