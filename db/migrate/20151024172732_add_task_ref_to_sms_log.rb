class AddTaskRefToSmsLog < ActiveRecord::Migration
  def change
    add_reference :sms_logs, :task, index: true, foreign_key: true
  end
end
