class Poker::StartGame < Service
  attr_reader :dealer_hand, :player_hands

  def initialize(dealer_hand:, player_hands: [], debug: false)
    @dealer_hand = dealer_hand
    @player_hands = player_hands
    @debug = debug
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

    return unless @debug

    # puts "[莊家]   #{dealer_hand.score.to_s.rjust(3)}妞, #{dealer_hand.readable_cards},              戰機: #{dealer_hand.win_lose_amount}"
    # player_hands.each_with_index do |player_hand, i|
    #   puts "[玩家 #{i+1}] #{player_hand.score.to_s.rjust(3)}妞, #{player_hand.readable_cards}, 下注: #{player_hand.bet_amount}元, 戰機: #{player_hand.win_lose_amount}"
    # end
  end
end
