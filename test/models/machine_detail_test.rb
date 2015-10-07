# == Schema Information
#
# Table name: machine_details
#
#  id                       :integer          not null, primary key
#  cpu_name                 :string(255)
#  mhz                      :string(255)
#  cpu_real                 :integer
#  cpu_total                :integer
#  memory_swap_total        :string(255)
#  memory_total             :string(255)
#  network_external_address :string(255)
#  network_address          :string(255)
#  machine_id               :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'test_helper'

class MachineDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
