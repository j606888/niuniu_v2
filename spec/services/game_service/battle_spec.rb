require 'rails_helper'

describe GameService::Battle do
  let!(:line_group) { create(:line_group) }
  let!(:dealer) { create(:player, line_group: line_group) }
  let!(:player) { create(:player, line_group: line_group) }
  let!(:game) { create(:game, line_group: line_group, dealer: dealer, max_bet_amount: 100, aasm_state: 'bets_locked') }
  let!(:player_bet_record) { create(:bet_record, game: game, player: player, bet_amount: 30) }
  let(:params) do
    {
      dealer_id: dealer.id,
      line_group_id: line_group.id
    }
  end
  let(:service) { described_class.new(**params) }

  it "end game" do
    service.perform

    expect(game.reload.aasm_state).to eq("game_ended")
  end

  it "create bet_record for dealer" do
    service.perform

    dealer_bet_record = BetRecord.find_by(player: dealer, game: game)
    expect(dealer_bet_record).to be_present
    expect(dealer_bet_record.cards.length).to eq(5)
  end

  it "set cards and win_amount for player_bet_record" do
    service.perform

    dealer_bet_record = BetRecord.find_by(player: dealer, game: game)
    player_bet_record.reload
    expect(player_bet_record.cards.length).to eq(5)
    expect(player_bet_record.win_amount).not_to be_nil
    expect(player_bet_record.win_amount * -1).to eq(dealer_bet_record.win_amount)
  end
end
