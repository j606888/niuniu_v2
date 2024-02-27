class Game < ApplicationRecord
  include AASM

  belongs_to :line_group
  has_many :bet_records

  aasm do
    state :bets_opened, initial: true
    state :bets_locked
    state :battle_started
    state :game_ended
    state :game_canceled

    event :lock_bets do
      transitions from: :bets_opened, to: :bets_locked
    end

    event :start_battle do
      transitions from: :bets_locked, to: :battle_started
    end

    event :end_game do
      transitions from: :battle_started, to: :game_ended
    end

    event :cancel_game do
      transitions from: [:bets_opened, :bets_locked], to: :game_ended
    end
  end
end
