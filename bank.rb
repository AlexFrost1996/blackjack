class Bank
  attr_reader :bank
  def initialize
    @bank = 0
  end

  def prize(divider = 1)
    prize = @bank / divider
    @bank = 0
    prize
  end
end
