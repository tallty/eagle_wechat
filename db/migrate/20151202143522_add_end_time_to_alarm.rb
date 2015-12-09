class AddEndTimeToAlarm < ActiveRecord::Migration
  def change
    add_column :alarms, :end_time, :datetime
  end
end
