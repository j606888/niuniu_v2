class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.references :line_group, null: false, foreign_key: true
      t.string :aasm_state, null: false
      t.integer :max_bet_amount, null: false

      t.timestamps
    end
  end
end
