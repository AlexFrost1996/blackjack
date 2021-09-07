# frozen_string_literal: true

class Hand
  attr_reader :total_value

  def initialize
    @hand = []
    @total_value = 0
  end

  def take_card(card)
    @hand.concat(card)
    current_value
    ace_and_more_21?
  end

  def show
    @hand.map(&:show) * ', '
  end

  def hide
    @hand.map(&:hide) * ''
  end

  def three_card?
    @hand.size == 3
  end

  private

  def current_value
    @total_value = @hand.map(&:value).sum
  end

  def ace?
    @hand.map(&:face).include?('A')
  end

  def ace_and_more_21?
    @total_value -= 10 if ace? && total_value > 21
  end
end
