class CreateMemoryInfos < ActiveRecord::Migration
  def change
    create_table :memory_infos do |t|
      t.integer :swap_total
      t.integer :total

      t.references :machine, index:true
      t.timestamps null: false
    end
  end
end
