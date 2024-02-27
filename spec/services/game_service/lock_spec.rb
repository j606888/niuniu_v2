require 'rails_helper'

describe GameService::Lock do
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

  it "lock the game" do
    service.perform

    expect(game.reload.aasm_state).to eq("bets_locked")
  end

  it "raise error if player is not dealer" do
    params[:player_id] = player.id

    expect { service.perform }.to raise_error("Player is not dealer")
  end

  it "raise error if only one player" do
    BetRecord.last.destroy

    expect { service.perform }.to raise_error("At least two players are required to start the game.")
  end

  it "raise error if game is not aasm_state `bets_opened`" do
    game.update!(aasm_state: 'bets_locked')

    expect { service.perform }.to raise_error("There is no ongoing game in this line group.")
  end
end
