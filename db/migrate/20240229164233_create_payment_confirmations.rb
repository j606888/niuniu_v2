class CreatePaymentConfirmations < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_confirmations do |t|
      t.references :game_bundle, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.integer :amount, null: false
      t.boolean :is_confirmed, default: false

      t.timestamps
    end
  end
end
