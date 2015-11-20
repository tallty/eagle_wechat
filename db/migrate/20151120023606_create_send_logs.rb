class CreateSendLogs < ActiveRecord::Migration
  def change
    create_table :send_logs do |t|
    	t.integer :alarm_id
      t.string :accept_user
      t.string :info

      t.timestamps null: false
    end
  end
end
