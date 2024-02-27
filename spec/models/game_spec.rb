require 'rails_helper'

RSpec.describe Game, type: :model do
  let!(:game) { create(:game) }

  it 'starts with bets_opened state' do
    expect(game.aasm_state).to eq('bets_opened')
  end

  it 'transitions from betting_open to bets_locked' do
    game.lock_bets
    expect(game.aasm_state).to eq('bets_locked')
  end
end
