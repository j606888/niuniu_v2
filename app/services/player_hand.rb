class PlayerHand
  def initialize(cards, is_dealer: false)
    @cards = cards
    # @is_dealer = is_dealer
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

  def battle(other_player_score, bet_amount)
    return 0 if score == other_player_score

    odds = PokerHelper.calculate_odd([score, other_player_score])
    win = score > other_player_score ? 1 : -1

    bet_amount * odds * win
  end

  private

  def found_combination
    return @found_combination if defined? @found_combination

    @found_combination = @cards.combination(3).find do |combo|
      combo.map { |card| PokerHelper.card_value(card) }.sum % 10 == 0
    end
  end
end
