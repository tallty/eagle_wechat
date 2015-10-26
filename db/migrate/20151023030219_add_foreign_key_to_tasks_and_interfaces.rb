class AddForeignKeyToTasksAndInterfaces < ActiveRecord::Migration
  def change
  	add_column :tasks, :customer_id, :integer
  	add_column :interfaces, :customer_id, :integer
  end
end
