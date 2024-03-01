class GameBundle < ApplicationRecord
  include AASM

  belongs_to :line_group
  has_many :games
  has_many :payment_confirmations

   aasm do
    state :created, initial: true
    state :confirmed

    event :aasm_confirm do
      transitions from: :created, to: :confirmed
    end
  end
end
