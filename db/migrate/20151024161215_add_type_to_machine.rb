class AddTypeToMachine < ActiveRecord::Migration
  def change
    add_column :machines, :cpu_type, :string
  end
end
