class GameBundle < ApplicationRecord
  belongs_to :line_group
  has_many :games
end
