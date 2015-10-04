class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :addr
      t.string :explain
      t.string :abbreviation
      
      t.timestamps null: false
    end
    add_index :customers, :name
  end
end
