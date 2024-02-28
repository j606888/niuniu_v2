require 'rails_helper'

describe GameService::PlayerBet do
  let!(:line_group) { create(:line_group) }
  let!(:player) { create(:player, line_group: line_group) }
  let!(:game) { create(:game, line_group: line_group, max_bet_amount: 100) }
  let(:params) do
    {
      line_group_id: line_group.id,
      player_id: player.id,
      bet_amount: 50
    }
  end
  let(:service) { described_class.new(**params) }

  it "create a new bet record for the player" do
    bet_record = service.perform
    expect(bet_record.player).to eq(player)
    expect(bet_record.game).to eq(game)
    expect(bet_record.bet_amount).to eq(50)
    expect(bet_record.cards).to eq([])
  end

  it "raise error if player does not belong to line group" do
    player.update!(line_group: create(:line_group))

    expect { service.perform }.to raise_error("Player does not belong to this line group.")
  end

  it "raise error if there is no ongoing game in this line group" do
    game.update!(aasm_state: "game_canceled")

    expect { service.perform }.to raise_error("There is no ongoing game in this line group.")
  end

  it "raise error if bet_amount over max_bet_amount" do
    params[:bet_amount] = 500

    expect { service.perform }.to raise_error("bet_amount over max_bet_amount")
  end
end
