class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :openid
      t.string :nick_name
      t.string :headimg
      
      t.references :customer, index: true

      t.timestamps null: false
    end
  end
end
