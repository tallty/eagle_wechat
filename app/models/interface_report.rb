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
#  sum_count    :integer
#

class InterfaceReport < ActiveRecord::Base

  def self.process
    now_date = Time.now.to_date - 1.day
    list = TotalInterface.day(now_date)
    list.each do |item|
      report = InterfaceReport.find_or_create_by datetime: now_date, identifier: 'X548EYTO', name: item[0]
      report.sum_count = item[1].to_i
      report
    end
  end
end
