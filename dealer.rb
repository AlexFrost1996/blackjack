class Dealer < User
  def initialize
    super
    @user = 'Dealer'
  end

  def enough?
    hand.total_value >= 17
  end
end
