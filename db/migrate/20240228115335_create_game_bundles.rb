class CreateGameBundles < ActiveRecord::Migration[7.0]
  def change
    create_table :game_bundles do |t|
      t.references :line_group, null: false, foreign_key: true
      t.string :aasm_state

      t.timestamps
    end
  end
end
