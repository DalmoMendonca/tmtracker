class RemoveSpeechIdFromCharts < ActiveRecord::Migration
  def change
    remove_column :charts, :speech_id, :integer
  end
end
