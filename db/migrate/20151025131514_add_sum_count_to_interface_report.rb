class AddSumCountToInterfaceReport < ActiveRecord::Migration
  def change
    add_column :interface_reports, :sum_count, :integer
  end
end
