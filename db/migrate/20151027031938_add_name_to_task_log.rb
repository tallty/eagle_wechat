class AddNameToTaskLog < ActiveRecord::Migration
  def change
    add_column :task_logs, :task_name, :string
    add_column :task_logs, :identifier, :string
    add_index :task_logs, :identifier
    add_index :task_logs, :start_time
  end
end
