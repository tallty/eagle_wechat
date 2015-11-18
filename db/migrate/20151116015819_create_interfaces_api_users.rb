class CreateInterfacesApiUsers < ActiveRecord::Migration
  def change
    create_table :interfaces_api_users do |t|
      t.references :interface, index: true, foreign_key: true
      t.references :api_user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
