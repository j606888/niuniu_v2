class Poker::StartGame < Service
  attr_reader :dealer_hand, :player_hands

  def initialize(dealer_hand:, player_hands: [])
    @dealer_hand = dealer_hand
    @player_hands = player_hands
  end

  def perform
    card_deck = (1..52).to_a.shuffle.shuffle

    5.times do
      (player_hands + [dealer_hand]).each do |hand|
        hand.pick_card(card_deck.pop)
      end
    end

    player_hands.each do |player_hand|
      player_hand.battle(dealer_hand.score)
    end

    dealer_hand.calculate_win_lose_amount(player_hands)
  end
end
