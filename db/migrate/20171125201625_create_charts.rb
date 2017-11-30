class CreateCharts < ActiveRecord::Migration
  def change
    create_table :charts do |t|
      t.string :name
      t.integer :member_id
      t.integer :speech_id

      t.timestamps null: false
    end
    add_index :charts, :member_id
    add_index :charts, :speech_id
  end
end
