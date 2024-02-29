class PaymentConfirmation < ApplicationRecord
  belongs_to :game_bundle
  belongs_to :player
end
