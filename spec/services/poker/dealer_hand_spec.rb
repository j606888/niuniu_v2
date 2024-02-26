require 'rails_helper'

RSpec.describe Poker::DealerHand do
  describe '#calculate_win_lose_amount' do
    let!(:player_hands) do
      3.times.map do
        player_hand = Poker::PlayerHand.new(bet_amount: 100)
        cards = [1, 2, 3, 4, 7]
        cards.each { |card| player_hand.pick_card(card) }
        player_hand
      end
    end
    let(:dealer_hand) do
      dh = described_class.new
      cards = [1, 2, 3, 9, 5]
      cards.each { |card| dh.pick_card(card) } # score 10
      dh
    end

    it "wins 300 * 3 = 900" do
      player_hands.each { |ph| ph.battle(dealer_hand.score) }
      dealer_hand.calculate_win_lose_amount(player_hands)
      expect(dealer_hand.win_lose_amount).to eq(900)
    end
  end
end
