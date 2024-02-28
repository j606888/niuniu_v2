class Player < ApplicationRecord
  belongs_to :line_group
  has_many :bet_records
end
