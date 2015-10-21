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

class MachineDetail < ActiveRecord::Base
  belongs_to :machine

  def cpu_percent
  	#top = eval(MachineInfo.get_info("cpu", identifier))["top"].to_f
  end

  def memory_percent
  	memory_data = eval(MachineInfo.get_info("memory", identifier)) 
  	memory_free_bytes = memory_data["memory_free_bytes"].to_f
  	memory_total_bytes = memory_data["memory_total_bytes"].to_f
  	memory_use = (((memory_total_bytes - memory_free_bytes) / memory_total_bytes) * 100).round(1)
  	"#{memory_use}%"
  end
end
