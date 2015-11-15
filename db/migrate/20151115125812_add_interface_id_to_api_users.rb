class AddInterfaceIdToApiUsers < ActiveRecord::Migration
  def change
    add_column :api_users, :interface_id, :integer
  end
end
