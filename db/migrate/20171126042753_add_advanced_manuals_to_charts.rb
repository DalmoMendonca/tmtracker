class AddAdvancedManualsToCharts < ActiveRecord::Migration
  def change
    add_column :charts, :advancedManual, :array
  end
end
