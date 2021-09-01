require_relative 'bank'
require_relative 'hand'
require_relative 'user'
require_relative 'dealer'
require_relative 'deck'

class Game
  attr_accessor :user, :dealer, :deck, :bank, :wins
  
  MENU_CHOICE = [
    {index: 1, title: 'pass', action: 'user_pass'},
    {index: 2, title: 'take card', action: 'user_take_card'},
    {index: 3, title: 'open cards', action: 'open_cards'}
  ].freeze

  def initialize
    @user = User.new
    @dealer = Dealer.new
    @deck = Deck.new
    @bank = Bank.new
    @end_round = false
    @wins = {user: 0, dealer: 0}
    start
  end

  def start
    take_bets
    user_take_card(2)
    dealer_take_card(2)
    user_choice
    dealer_choice
    winner
    new_round
  end

  def user_take_card(quantity = 1)
    user.hand.take_card(deck.deal(quantity))
    puts "#{user.name}, value in your hand = #{user.hand.total_value}"
  end

  def dealer_take_card(quantity = 1)
    dealer.hand.take_card(deck.deal(quantity))
  end

  def take_bets
    bank.bets(user.bet, dealer.bet)
  end

  def user_choice
    puts 'Enter you choice'
    MENU_CHOISE.each { |item| puts "#{item[:index]}: #{item[:title]}" }
    choice = gets.chomp.to_i
    need_item = MENU_CHOISE.find { |item| item[:index] == choice }
    send(need_item[:action])
  end

  def dealer_choice
    if dealer.enough?
      dealer_pass
    else
      dealer_take_card
    end
  end

  def winner
    if user_lost? && dealer_lost?
      tie_prize
    elsif user_lost?
      dealer_wins
    elsif dealer_lost?
      user_wins
    elsif user_have_more_points?
      user_wins
    elsif dealer_have_more_points?
      dealer_wins
    else
      tie_prize
    end
  end

  def user_pass
    user.pass = true
  end

  def open_cards
    @end_round = true
  end

  def dealer_pass
    dealer.pass = true
  end

  def both_pass?
    user.pass? && dealer.pass?
  end

  def both_have_three_card?
    user.hand.three_card? && dealer.hand.three_card?
  end

  def limit_moves?
    (user.hand.three_card? && user.pass?) || (dealer.hand.three_card? && dealer.pass?)
  end

  def end_round?
    return true if open_cards || both_pass? || both_have_three_card? || limit_moves?

    false
  end

  def user_points
    user.hand.total_value
  end

  def dealer_points
    dealer.hand.total_value
  end

  def user_lost?
    user_points > 21
  end

  def dealer_lost?
    dealer_points > 21
  end

  def user_have_more_points?
    user_points > dealer_points
  end

  def dealer_have_more_points?
    dealer_points > user_points
  end

  def user_wins
    winner_prize(user)
    wins[:user] += 1
  end

  def dealer_wins
    winner_prize(dealer)
    wins[:dealer] += 1
  end

  def winner_prize(player)
    player.bankroll += bank.prize
  end

  def tie_prize
    tie_prize = bank.prize(2)
    user.bankroll += tie_prize
    user.bankroll += tie_prize
  end

  def new_round
    clear_data
    start
  end

  def clear_data
    deck = Deck.new
    user.hand = Hand.new
    dealer.hand = Hand.new
    user.pass = false
    dealer.pass = false
    @end_round = false
  end
end