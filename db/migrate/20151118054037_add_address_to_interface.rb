class AddAddressToInterface < ActiveRecord::Migration
  def change
    add_column :interfaces, :address, :string
  end
end
