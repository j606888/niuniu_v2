class CreateLineGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :line_groups do |t|
      t.string :name
      t.string :group_id
      t.string :room_id

      t.timestamps
    end
  end
end
