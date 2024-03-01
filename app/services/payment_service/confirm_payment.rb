class PaymentService::ConfirmPayment < Service
  def initialize(game_bundle_id:, player_id:)
    @game_bundle_id = game_bundle_id
    @player_id = player_id
  end

  def perform
    game_bundle = GameBundle.find(@game_bundle_id)
    payment_confirmation = PaymentConfirmation.find_by(game_bundle_id: @game_bundle_id, player_id: @player_id)

    raise "payment_confirmation not found" if payment_confirmation.nil?
    raise "Already confirmed" if payment_confirmation.is_confirmed

    payment_confirmation.update!(is_confirmed: true)

    if game_bundle.payment_confirmations.all?(&:is_confirmed)
      game_bundle.aasm_confirm!
    end
  end
end
