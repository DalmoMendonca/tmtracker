class CreateSpeeches < ActiveRecord::Migration
  def change
    create_table :speeches do |t|
      t.string :manual
      t.string :project
      t.string :title
      t.date :date
      t.string :club
      t.string :comment
      t.integer :chart_id

      t.timestamps null: false
    end
    add_index :speeches, :chart_id
  end
end
