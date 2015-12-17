class AddProcesserToAlarm < ActiveRecord::Migration
  def change
    add_reference :alarms, :user, index: true
  end
end
