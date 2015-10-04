class CreateCpus < ActiveRecord::Migration
  def change
    create_table :cpus do |t|
      t.string :model_info
      t.string :mhz
      t.string :cache_size

      t.references :machine, index:true

      t.timestamps null: false
    end
  end
end
