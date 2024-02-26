require 'rails_helper'

RSpec.describe Poker::DealerHand do
  describe '#calculate_win_lose_amount' do
    let!(:player_hands) do
      3.times.map do
        player_hand = Poker::PlayerHand.new(bet_amount: 100)
        player_hand.pick_cards([1, 2, 3, 4, 7]) # score 7
        player_hand
      end
    end
    let(:dealer_hand) do
      dh = described_class.new
      dh.pick_cards([1, 2, 3, 9, 5]) # score 10
      dh
    end

    it "wins 300 * 3 = 900" do
      player_hands.each { |ph| ph.battle(dealer_hand.score) }
      dealer_hand.calculate_win_lose_amount(player_hands)
      expect(dealer_hand.win_lose_amount).to eq(900)
    end
  end
end
