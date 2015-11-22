class AddContentToAlarm < ActiveRecord::Migration
  def change
    add_column :alarms, :content, :string
  end
end
