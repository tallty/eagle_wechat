class AddProcesserToAlarm < ActiveRecord::Migration
  def change
    add_column :alarms, :processer, :string
  end
end
