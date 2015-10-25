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

  def as_json(options=nil)
    {
      datetime: datetime.strftime("%Y-%m-%d"),
      identifier: identifier,
      name: name,
      sum_count: sum_count,
      first_times: first_times,
      first_count: first_count,
      second_times: second_count,
      third_times: third_times,
      third_count: third_count
    }  
  end

  def self.process
    now_date = Time.now.to_date - 1.day
    list = TotalInterface.by_day(now_date).distinct(:name).pluck(:name)
    identifier = "X548EYTO"
    list.each do |item|
      data = InterfaceReport.find_or_create_by datetime: now_date, identifier: identifier, name: item
      data.sum_count = TotalInterface.by_day(now_date).where(name: item).sum(:count)
      items = TotalInterface.by_day(now_date).where(name: item).order("count asc").first(3)
      data.first_times = items[0].datetime
      data.first_count = items[0].count
      data.second_times = items[1].datetime
      data.second_count = items[1].count
      data.third_times = items[2].datetime
      data.third_count = items[2].count
      data.save
      $redis.hset "interface_reports_cache_#{now_date.strftime('%Y-%m-%d')}", "#{data.name}", data.to_json
    end

    $redis.hset "interface_sum_cache", "#{identifier}_#{now_date.strftime('%Y-%m-%d')}", TotalInterface.by_day(now_date).sum(:count)
  end
end
