# == Schema Information
#
# Table name: interface_reports
#
#  id           :integer          not null, primary key
#  datetime     :datetime
#  identifier   :string(255)
#  name         :string(255)
#  first_times  :string(255)
#  second_times :string(255)
#  third_times  :string(255)
#  first_count  :integer
#  second_count :integer
#  third_count  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class InterfaceReport < ActiveRecord::Base

  def self.process
    now_date = Time.now.to_date - 1.day
    list = TotalInterface.day(now_date)
    list.each do |item|
      p item
    end
  end
end
