require 'rails_helper'

describe GameService::Cancel do
  let!(:line_group) { create(:line_group) }
  let!(:dealer) { create(:player, line_group: line_group) }
  let!(:player) { create(:player, line_group: line_group) }
  let!(:game) { create(:game, line_group: line_group, dealer: dealer) }
  let(:params) do
    {
      line_group_id: line_group.id,
      player_id: dealer.id
    }
  end
  let(:service) { described_class.new(**params) }

  before do
    create :bet_record, game: game, player: dealer
    create :bet_record, game: game, player: player, bet_amount: 50
  end

  it "cancel the game" do
    service.perform

    expect(game.reload.aasm_state).to eq("game_canceled")
  end

  it "can cancel by other player" do
    params[:player_id] = player.id

    service.perform

    expect(game.reload.aasm_state).to eq("game_canceled")
  end

  it "raise error if game is not `bets_opened`" do
    game.update!(aasm_state: 'battle_started')

    expect { service.perform }.to raise_error("There is no ongoing game in this line group.")
  end
end
