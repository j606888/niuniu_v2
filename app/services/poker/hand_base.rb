class Poker::HandBase
  attr_accessor :cards
  attr_reader :win_lose_amount, :readable_cards

  CARD_AMOUNT = 5

  def initialize
    @cards = []
    @win_lose_amount = nil
  end

  def pick_card(card)
    raise "Too many cards" if @cards.length >= CARD_AMOUNT

    @cards << card
  end

  def score
    return -1 if found_combination.nil?

    remaining_cards = @cards - found_combination
    real_score = remaining_cards.map { |card| PokerHelper.card_value(card) }.sum % 10
    real_score == 0 ? 10 : real_score
  end

  def cards_with_order
    return @cards if found_combination.nil?

    found_combination + (@cards - found_combination)
  end

  def readable_cards
    cards_with_order.map { |card| PokerHelper.readable_card(card) }
  end

  private

  def found_combination
    return @found_combination if defined? @found_combination

    raise "Cards amount invalid" if @cards.length != CARD_AMOUNT

    @found_combination = @cards.combination(3).find do |combo|
      combo.map { |card| PokerHelper.card_value(card) }.sum % 10 == 0
    end
  end
end
