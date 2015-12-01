class AddAlarmThresholdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :alarm_threshold, :integer
  end
end
