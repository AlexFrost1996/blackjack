# frozen_string_literal: true

require_relative 'bank'
require_relative 'hand'
require_relative 'user'
require_relative 'card'
require_relative 'dealer'
require_relative 'deck'

class Game
  attr_accessor :user, :dealer, :deck, :bank, :wins

  MENU_CHOICE = [
    { index: 1, title: 'pass', action: :user_pass },
    { index: 2, title: 'take card', action: :user_take_card },
    { index: 3, title: 'open cards', action: :open_cards }
  ].freeze

  NEW_ROUND = [
    { index: 1, title: 'start new nound', action: :new_round },
    { index: 2, title: 'quit the game', action: :quit }
  ].freeze

  def initialize
    @user = User.new
    @dealer = Dealer.new
    @deck = Deck.new
    @bank = Bank.new
    @end_round = false
    @wins = { user: 0, dealer: 0 }
    start
  end

  def start
    take_bets
    user_take_card(2)
    dealer_take_card(2)
    player_choice
    winner
    new_round?
  end

  def player_choice
    user_choice
    dealer_choice
    status
  end

  def user_take_card(quantity = 1)
    user.hand.take_card(deck.deal(quantity))
  end

  def dealer_take_card(quantity = 1)
    dealer.hand.take_card(deck.deal(quantity))
  end

  def take_bets
    bank.bets(user.bet, dealer.bet)
  end

  def user_choice
    user_show
    puts 'Enter you choice'
    MENU_CHOICE.each { |item| puts "#{item[:index]}: #{item[:title]}" }
    choice = gets.chomp.to_i
    need_item = MENU_CHOICE.find { |item| item[:index] == choice }
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
    if user_lost? || dealer_have_more_points?
      dealer_wins
    elsif dealer_lost? || user_have_more_points?
      user_wins
    elsif user_lost? && dealer_lost?
      tie_prize
    else
      tie_prize
    end
    status
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

  def status
    bank_show
    user_show
    dealer_show
  end

  def bank_show
    puts "Bank on this round: #{bank.bank}"
  end

  def user_show
    puts "#{user.name}:
    Bankroll: #{user.bankroll}
    Cards:    #{user.hand.show}
    Points:   #{user.hand.total_value}
    Wins:     #{wins[:user]}"
  end

  def dealer_show
    puts "#{dealer.name}:
    Bankroll: #{dealer.bankroll}
    Cards:    #{open_cards ? dealer.hand.show : dealer.hand.hide}
    Points:   #{open_cards ? dealer.hand.total_value : '**'}
    Wins:     #{wins[:dealer]}"
  end

  def wins_status
    puts "#{user.name} wins: #{wins[:user]}"
    puts "#{dealer.name} wins: #{wins[:dealer]}"
  end

  def new_round?
    puts 'Enter you choice'
    NEW_ROUND.each { |item| puts "#{item[:index]}: #{item[:title]}" }
    choice = gets.chomp.to_i
    need_item = NEW_ROUND.find { |item| item[:index] == choice }
    send(need_item[:action])
  end

  def new_round
    wins_status
    clear_data
    start
  end

  def quit
    puts 'GAME OVER! Bye!'
    exit(0)
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

Game.new
