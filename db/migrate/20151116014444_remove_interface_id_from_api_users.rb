class RemoveInterfaceIdFromApiUsers < ActiveRecord::Migration
  def change
    remove_column :api_users, :interface_id, :integer
  end
end
