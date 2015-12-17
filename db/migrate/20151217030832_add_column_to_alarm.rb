class AddColumnToAlarm < ActiveRecord::Migration
  def change
    add_column :alarms, :info, :text
    add_column :alarms, :end_time, :datetime
    add_reference :alarms, :customer, index: true
  end
end
