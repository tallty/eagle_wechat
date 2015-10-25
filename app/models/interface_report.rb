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
    list = TotalInterface.by_day(now_date).distinct(:name).pluck(:name)
    list.each do |item|
      data = InterfaceReport.find_or_create_by datetime: now_date, identifier: 'X548EYTO', name: item
      data.sum_count = TotalInterface.by_day(now_date).where(name: item).sum(:count)
      items = TotalInterface.by_day(Time.now.to_date - 1.day).where(name: item).order("count asc").first(3)
      data.first_times = items[0].datetime
      data.first_count = items[0].count
      data.second_times = items[1].datetime
      data.second_count = items[1].count
      data.third_times = items[2].datetime
      data.third_count = items[2].count
      data.save
      $redis.hset "interface_reports_cache_#{now_date.strftime('%Y-%m-%d')}", "#{data.name}", data.to_json
    end
  end
end
