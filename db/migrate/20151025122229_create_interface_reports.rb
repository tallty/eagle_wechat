class CreateInterfaceReports < ActiveRecord::Migration
  def change
    create_table :interface_reports do |t|
      t.datetime :datetime
      t.string :identifier
      t.string :name
      t.string :first_times
      t.string :second_times
      t.string :third_times
      t.integer :first_count
      t.integer :second_count
      t.integer :third_count

      t.timestamps null: false
    end
    add_index :interface_reports, :datetime
    add_index :interface_reports, :identifier
    add_index :interface_reports, :name
  end
end
