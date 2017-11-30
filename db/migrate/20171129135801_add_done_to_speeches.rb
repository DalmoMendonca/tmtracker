class AddDoneToSpeeches < ActiveRecord::Migration
  def change
    add_column :speeches, :done, :boolean
  end
end
