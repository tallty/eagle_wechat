class AddWarningStateToSmsLog < ActiveRecord::Migration
  def change
    add_column :sms_logs, :warning_state, :boolean
  end
end
