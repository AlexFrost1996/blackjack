# frozen_string_literal: true

class Bank
  attr_reader :bank

  def initialize
    @bank = 0
  end

  def bets(*params)
    params.each { |param| @bank += param }
  end

  def prize(divider = 1)
    prize = @bank / divider
    @bank = 0
    prize
  end
end
