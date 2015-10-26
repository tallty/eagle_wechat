class AddIdentifierToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :identifier, :string, unique: true
  end
end
