class CreateMachines < ActiveRecord::Migration
  def change
    create_table :machines do |t|
      t.string :identifier
      t.string :name
      t.string :explain
      t.integer :operating_status, default: 0

      t.references :customer, index:true
      t.timestamps null: false
    end
    add_index :machines, :identifier
  end
end
