class CreateSmsLogs < ActiveRecord::Migration
  def change
    create_table :sms_logs do |t|
      t.string :content
      t.references :customer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
