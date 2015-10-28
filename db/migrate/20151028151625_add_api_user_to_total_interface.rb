class AddApiUserToTotalInterface < ActiveRecord::Migration
  def change
    add_reference :total_interfaces, :api_user, index: true
  end
end
