class CreateAlarms < ActiveRecord::Migration
  def change
    create_table :alarms do |t|
      t.string :title
      t.string :category
      t.datetime :alarmed_at

      t.timestamps null: false
    end
  end
end
