class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :identifier
      t.string :name
      t.int :rate

      t.timestamps null: false
    end
  end
end
