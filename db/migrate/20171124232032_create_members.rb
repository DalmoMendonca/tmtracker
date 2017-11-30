class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name
      t.string :level
      t.string :communicationGoal
      t.string :leadershipGoal
      t.string :club

      t.timestamps null: false
    end
  end
end
