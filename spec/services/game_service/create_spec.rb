require 'rails_helper'

describe GameService::Create do
  let!(:line_group) { create(:line_group) }
  let!(:player) { create(:player, line_group: line_group) }
  let(:params) do
    {
      player_id: player.id,
      line_group_id: line_group.id,
      max_bet_amount: 100
    }
  end
  let(:service) { described_class.new(**params) }

  it "create a new game" do
    game = service.perform

    expect(game.dealer).to eq(player)
    expect(game.line_group).to eq(line_group)
    expect(game.max_bet_amount).to eq(100)
  end

  it "create a new bet record for the player" do
    service.perform

    bet_record = BetRecord.last
    expect(bet_record.player).to eq(player)
    expect(bet_record.cards).to eq([])
    expect(bet_record.bet_amount).to eq(nil)
    expect(bet_record.win_amount).to eq(nil)
  end

  it "raise error if player does not belong to line group" do
    player.update(line_group: create(:line_group))

    expect { service.perform }.to raise_error("Player does not belong to this line group.")
  end

  it "raise error if there is an ongoing game in this line group" do
    create(:game, line_group: line_group)

    expect { service.perform }.to raise_error("There is an ongoing game in this line group.")
  end
end
