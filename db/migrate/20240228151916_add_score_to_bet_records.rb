class AddScoreToBetRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :bet_records, :score, :integer
  end
end
