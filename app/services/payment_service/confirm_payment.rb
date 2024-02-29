class PaymentService::ConfirmPayment < Service
  def initialize(game_bundle_id:, player_id:)
    @game_bundle_id = game_bundle_id
    @player_id = player_id
  end

  def perform
    payment_confirmation = PaymentConfirmation.find_by(game_bundle_id: @game_bundle_id, player_id: @player_id)

    raise "payment_confirmation not found" if payment_confirmation.nil?
    raise "Already confirmed" if payment_confirmation.is_confirmed

    payment_confirmation.update!(is_confirmed: true)
  end
end
