require 'rails_helper'

RSpec.describe Poker::HandBase do
  let(:hand_base) { described_class.new }

  describe '#score' do
    it 'returns -1 if no combination is found' do
      cards = [2, 15, 5, 18, 31] # 黑桃2, 紅心2, 黑桃4, 紅心5, 方塊5 -> 無牛
      hand_base.pick_cards(cards)
      expect(hand_base.score).to eq(-1)
    end

    it 'return correct score if combination is found' do
      cards = [1, 14, 10, 7, 8] # 黑桃A, 紅心A, 黑桃10, 黑桃7, 黑桃8 -> 妞妞
      hand_base.pick_cards(cards)
      expect(hand_base.score).to eq(7)
    end

    it 'return 10 if score is 0' do
      cards = [1, 14, 10, 24, 8] # 黑桃A, 紅心A, 黑桃10, 紅心J, 黑桃8 -> 妞妞
      hand_base.pick_cards(cards)
      expect(hand_base.score).to eq(10)
    end
  end

  describe '#cards_with_order' do
    it 'returns the cards with the combination first' do
      cards = [1, 14, 10, 11, 8]
      hand_base.pick_cards(cards)
      expect(hand_base.cards_with_order).to eq([1, 14, 8, 10, 11])
    end

    it 'returns same order if no combination is found' do
      cards = [2, 15, 5, 18, 31]
      hand_base.pick_cards(cards)
      expect(hand_base.cards_with_order).to eq(cards)
    end
  end
end
