class LineGroup < ApplicationRecord
  has_many :players
  has_many :games
  has_many :game_bundles
end
