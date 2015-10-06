class CreateMachineDetails < ActiveRecord::Migration
  def change
    create_table :machine_details do |t|
      t.string :cpu_name
      t.string :mhz
      t.integer :cpu_real
      t.integer :cpu_total
      t.string :memory_swap_total
      t.string :memory_total
      t.string :network_external_address
      t.string :network_address

      t.references :machine, index:true
      t.timestamps null: false
    end
    
  end
end
