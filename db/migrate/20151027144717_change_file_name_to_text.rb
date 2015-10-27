class ChangeFileNameToText < ActiveRecord::Migration
  def self.up
    change_column :task_logs, :file_name, :text
    remove_column :task_logs, :identifier
    add_index :task_logs, :task_identifier
  end

  def self.down
    change_column :task_logs, :file_name, :string
    add_column :task_logs, :identifier, :string
    remove_index :task_logs, :task_identifier
  end
end
