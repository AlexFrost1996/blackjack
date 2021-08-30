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

  def bet(BET)
    bankroupt!
    bankroll -= BET
  end

  def pass?
    @pass
  end

  private

  def bankroupt!
    raise "GAME OVER! No money, you bankroupt!" if bankroll.zero?
  end
end
