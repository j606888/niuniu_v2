require 'rails_helper'

RSpec.describe PlayerHand do
  describe '#score' do
    it 'returns -1 if no combination is found' do
      cards = [2, 15, 5, 18, 31] # 黑桃2, 紅心2, 黑桃4, 紅心5, 方塊5 -> 無牛
      player_hand = PlayerHand.new(cards)
      expect(player_hand.score).to eq(-1)
    end

    it 'return correct score if combination is found' do
      cards = [1, 14, 10, 7, 8] # 黑桃A, 紅心A, 黑桃10, 黑桃7, 黑桃8 -> 妞妞
      player_hand = PlayerHand.new(cards)
      expect(player_hand.score).to eq(7)
    end

    it 'return 10 if score is 0' do
      cards = [1, 14, 10, 24, 8] # 黑桃A, 紅心A, 黑桃10, 紅心J, 黑桃8 -> 妞妞
      player_hand = PlayerHand.new(cards)
      expect(player_hand.score).to eq(10)
    end
  end

  describe '#cards_with_order' do
    it 'returns the cards with the combination first' do
      cards = [1, 14, 10, 11, 8]
      player_hand = PlayerHand.new(cards)
      expect(player_hand.cards_with_order).to eq([1, 14, 8, 10, 11])
    end

    it 'returns same order if no combination is found' do
      cards = [2, 15, 5, 18, 31]
      player_hand = PlayerHand.new(cards)
      expect(player_hand.cards_with_order).to eq(cards)
    end
  end

  describe '#battle' do
    let(:player_hand) { PlayerHand.new([1, 2, 3, 4, 5]) }
    let(:bet_amount) { 100 }

    it 'returns 0 if scores are the same' do
      expect(player_hand.battle(5, bet_amount)).to eq(0)
    end

    it 'return 100 if win' do
      expect(player_hand.battle(4, bet_amount)).to eq(100)
    end

    it 'return -200 if lose and other player score if 8' do
      expect(player_hand.battle(8, bet_amount)).to eq(-200)
    end

    it 'return -300 if lose and other player score if 10' do
      expect(player_hand.battle(10, bet_amount)).to eq(-300)
    end
  end
end
