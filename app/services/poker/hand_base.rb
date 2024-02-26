class Poker::HandBase
  attr_accessor :cards
  attr_reader :win_lose_amount

  def initialize
    @cards = []
    @win_lose_amount = nil
  end

  def pick_cards(cards)
    raise "Cards already picked" if @cards.length > 0

    @cards = cards
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

  private

  def found_combination
    return @found_combination if defined? @found_combination

    @found_combination = @cards.combination(3).find do |combo|
      combo.map { |card| PokerHelper.card_value(card) }.sum % 10 == 0
    end
  end
end
