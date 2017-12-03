class AddProgresToCharts < ActiveRecord::Migration
  def change
    add_column :charts, :progress, :integer
  end
end
