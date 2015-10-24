class AddOpenIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :open_id, :string, unique: true
  end
end
