class AddDoneToCharts < ActiveRecord::Migration
  def change
    add_column :charts, :done, :date
  end
end
