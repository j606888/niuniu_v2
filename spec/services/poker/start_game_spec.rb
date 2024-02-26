require 'rails_helper'

RSpec.describe Poker::StartGame do
  let(:player_hand_1) { Poker::PlayerHand.new(bet_amount: 50) }
  let(:player_hand_2) { Poker::PlayerHand.new(bet_amount: 30) }
  let(:player_hand_3) { Poker::PlayerHand.new(bet_amount: 10) }
  let(:dealer_hand) { Poker::DealerHand.new }

  before do
    described_class.call(
      dealer_hand: dealer_hand,
      player_hands: [player_hand_1, player_hand_2, player_hand_3],
      # debug: true
    )
  end

  it "pick 5 cards for everyone" do
    [player_hand_1, player_hand_2, player_hand_3, dealer_hand].each do |hand|
      expect(hand.cards.length).to eq(5)
    end
  end

  it "calculate win_lose_amount for everyone" do
    player_scores = [player_hand_1, player_hand_2, player_hand_3].map(&:win_lose_amount).sum
    expect(dealer_hand.win_lose_amount).to eq(player_scores * -1)
  end
end
