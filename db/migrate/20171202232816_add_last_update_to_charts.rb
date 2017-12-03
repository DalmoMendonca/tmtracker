class AddLastUpdateToCharts < ActiveRecord::Migration
  def change
    add_column :charts, :lastUpdate, :date
  end
end
