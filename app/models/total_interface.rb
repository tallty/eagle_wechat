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
  
  def self.fix_name
    items = TotalInterface.all
    items.each do |item|
      interface = Interface.where(identifier: item.name).first
      next if interface.try(:name).blank?
      item.name = name
      item.save
    end
  end
end
