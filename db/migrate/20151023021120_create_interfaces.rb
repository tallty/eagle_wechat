class CreateInterfaces < ActiveRecord::Migration
  def change
    create_table :interfaces do |t|
      t.string :identifier
      t.string :name

      t.timestamps null: false
    end
  end
end
