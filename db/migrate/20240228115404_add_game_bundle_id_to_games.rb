class AddGameBundleIdToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :game_bundle_id, :integer
  end
end
