# == Schema Information
#
# Table name: disk_infos
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  full_name  :string(255)
#  disk_size  :integer
#  machine_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DiskInfo < ActiveRecord::Base
  belongs_to :machine
end
