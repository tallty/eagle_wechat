# == Schema Information
#
# Table name: total_interfaces
#
#  id         :integer          not null, primary key
#  datetime   :datetime
#  identifier :string(255)
#  name       :string(255)
#  count      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TotalInterface < ActiveRecord::Base
  by_star_field :datetime

  scope :day, -> (datetime) { TotalInterface.by_day(datetime).group(:name) }
  
  def self.process
    
  end
end
