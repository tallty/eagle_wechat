class CreateTaskLogs < ActiveRecord::Migration
  def change
    create_table :task_logs do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :task_identifier
      t.string :exception
      t.string :file_name

      t.timestamps null: false
    end
  end
end
