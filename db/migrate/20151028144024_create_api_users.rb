class CreateApiUsers < ActiveRecord::Migration
  def change
    create_table :api_users do |t|
      t.string :appid
      t.string :company
      
      t.references :customer, index: true
      t.timestamps null: false
    end
  end
end
