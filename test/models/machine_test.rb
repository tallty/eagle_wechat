# == Schema Information
#
# Table name: machines
#
#  id               :integer          not null, primary key
#  identifier       :string(255)
#  name             :string(255)
#  explain          :string(255)
#  operating_status :integer          default(0)
#  customer_id      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  cpu_type         :string(255)
#

require 'test_helper'

class MachineTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
