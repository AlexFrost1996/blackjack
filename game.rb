require_relative 'bank'
require_relative 'hand'
require_relative 'user'
require_relative 'dealer'
require_relative 'deck'

class Game
  attr_accessor :user, :dealer, :deck, :bank, :wins
  
  MENU_CHOICE = [
    {index: 1, title: 'pass', action: ''},
    {index: 2, title: 'add card', action: 'add_card'},
    {index: 3, title: 'open cards', action: 'open_cards'}
  ]

  def initialize
    @user = User.new
    @dealer = Dealer.new
    @deck = Deck.new
    @bank = Bank.new
    @wins = {user: 0, dealer: 0}
    start
  end

  def start
    user.hand.take_card(deck.deal(2))
    dealer.hand.take_card(deck.deal(2))
    user_choice
    dealer.hand.take_card(deck.deal) unless dealer.enough?
  end

  def user_choice
    puts 'Enter you choice'
    MENU_CHOISE.each { |item| puts "#{item[:index]}: #{item[:title]}" }
    choice = gets.chomp.to_i
    need_item = MENU_CHOISE.find { |item| item[:index] == choice }
    send(need_item[:action])
  end

  def pass
    user.pass = true
  end

  def add_card
    user.hand.take_card(deck.deal)
  end

  def open_cards
    user.hand.show
  end
end