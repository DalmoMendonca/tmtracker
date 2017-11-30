class AddAwardsToMembers < ActiveRecord::Migration
  def change
    add_column :members, :award, :string
  end
end
