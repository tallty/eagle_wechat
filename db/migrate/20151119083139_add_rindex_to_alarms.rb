class AddRindexToAlarms < ActiveRecord::Migration
  def change
    add_column :alarms, :rindex, :integer
    add_column :alarms, :identifier, :string
  end
end
