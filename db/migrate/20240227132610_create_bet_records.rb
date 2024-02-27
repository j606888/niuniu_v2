class CreateBetRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :bet_records do |t|
      t.references :game, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.integer :bet_amount
      t.json :cards
      t.integer :win_amount

      t.timestamps
    end
  end
end
