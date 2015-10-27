class CreateTotalInterfaces < ActiveRecord::Migration
  def change
    create_table :total_interfaces do |t|
      t.datetime :datetime
      t.string :identifier
      t.string :name
      t.integer :count

      t.timestamps null: false
    end
    add_index :total_interfaces, :datetime
    add_index :total_interfaces, :identifier
    add_index :total_interfaces, :name
  end
end
