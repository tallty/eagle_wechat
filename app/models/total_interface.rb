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
  belongs_to :api_user
  by_star_field :datetime

  attr_accessor :tops

  default_scope { order(count: :DESC) }

  scope :day, -> (datetime) { by_day(datetime).group(:name) }
  scope :select_fields, -> { select("total_interfaces.name, sum(total_interfaces.count) as total_count, GROUP_CONCAT(total_interfaces.id) as ids") }

  def self.fix_name
    items = TotalInterface.all
    items.each do |item|
      interface = Interface.where(identifier: item.name).first
      next if interface.try(:name).blank?
      item.name = name
      item.save
    end
  end

  def self.day_infos(current_customer, date)
    total_interfaces = current_customer.total_interfaces.select_fields.day(date)
    total_interfaces.each do |tl|
      tl.tops = TotalInterface.where(id: tl.ids.split(",")).limit(3).pluck(:datetime)
    end
    total_interfaces
  end

end
