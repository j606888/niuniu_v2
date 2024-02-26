require 'rails_helper'

RSpec.describe Poker::PlayerHand do
  describe '#battle' do
    let(:bet_amount) { 100}
    let(:player_hand) { described_class.new(bet_amount: bet_amount) }

    before do
      player_hand.pick_cards([1, 2, 3, 4, 5])
    end

    it 'returns 0 if scores are the same' do
      player_hand.battle(5)
      expect(player_hand.win_lose_amount).to eq(0)
    end

    it 'return 100 if win' do
      player_hand.battle(4)
      expect(player_hand.win_lose_amount).to eq(100)
    end

    it 'return -200 if lose and other player score if 8' do
      player_hand.battle(8)
      expect(player_hand.win_lose_amount).to eq(-200)
    end

    it 'return -300 if lose and other player score if 10' do
      player_hand.battle(10)
      expect(player_hand.win_lose_amount).to eq(-300)
    end
  end
end
