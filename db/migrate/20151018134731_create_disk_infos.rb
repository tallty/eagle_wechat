class CreateDiskInfos < ActiveRecord::Migration
  def change
    create_table :disk_infos do |t|
      t.string :name
      t.string :full_name
      t.integer :disk_size
      t.references :machine, index:true
      
      t.timestamps null: false
    end
  end
end
