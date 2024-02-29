class Game < ApplicationRecord
  include AASM

  belongs_to :line_group
  belongs_to :dealer, class_name: 'Player', foreign_key: 'dealer_id'
  belongs_to :game_bundle, optional: true
  has_many :bet_records

  scope :ongoing, -> { where(aasm_state: %w[bets_opened battle_started]) }

  validates :max_bet_amount, presence: true, numericality: { greater_than: 0 }

  aasm do
    state :bets_opened, initial: true
    state :battle_started
    state :game_ended
    state :game_canceled

    event :start_battle do
      transitions from: :bets_opened, to: :battle_started
    end

    event :end_game do
      transitions from: :battle_started, to: :game_ended
    end

    event :cancel_game do
      transitions from: :bets_opened, to: :game_ended
    end
  end
end
