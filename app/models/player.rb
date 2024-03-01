class Player < ApplicationRecord
  belongs_to :line_group
  has_many :bet_records
  has_many :payment_confirmations
end
