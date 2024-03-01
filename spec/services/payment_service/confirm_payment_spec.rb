require 'rails_helper'

describe PaymentService::ConfirmPayment do
  let!(:line_group) { create(:line_group) }
  let!(:game_bundle) { create(:game_bundle, line_group: line_group) }
  let!(:players) { create_list(:player, 2, line_group: line_group) }
  let!(:payment_confirmations) { players.map { |player| create(:payment_confirmation, game_bundle: game_bundle, player: player) } }
  let(:params) do
    {
      game_bundle_id: game_bundle.id,
      player_id: players[0].id
    }
  end
  let(:service) { described_class.new(**params) }

  it "confirm player payment" do
    expect(payment_confirmations[0].is_confirmed).to eq(false)

    service.perform

    expect(payment_confirmations[0].reload.is_confirmed).to eq(true)
  end

  context 'when all players have confirmed payment' do
    before do
      payment_confirmations[1].update!(is_confirmed: true)
    end

    it "confirm game_bundle" do
      expect(game_bundle.aasm_state).to eq("created")

      service.perform

      expect(game_bundle.reload.aasm_state).to eq("confirmed")
    end
  end
end
