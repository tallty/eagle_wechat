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
      second_times: second_times,
      second_count: second_count,
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
      data.first_times = items[0].try(:datetime)
      data.first_count = items[0].try(:count)
      data.second_times = items[1].try(:datetime)
      data.second_count = items[1].try(:count)
      data.third_times = items[2].try(:datetime)
      data.third_count = items[2].try(:count)
      data.save
      $redis.hset "interface_reports_cache_#{now_date.strftime('%Y-%m-%d')}", "#{data.name}", data.to_json
    end

    $redis.hset "interface_sum_cache", "#{identifier}_#{now_date.strftime('%Y-%m-%d')}", TotalInterface.by_day(now_date).sum(:count)
  end

  #时间段内的报表
  def self.reports_between_date(begin_date, end_date)
    sum_count = {}
    reports = [] 

    (begin_date..end_date).each do |date|
      r = $redis.hvals("interface_reports_cache_#{date.strftime("%F")}")
      cache = r.map { |e| MultiJson.load(e) }

      reports = cache if cache.present? && reports.blank?

      cache.each do |x|
        sum_count[x['name']].blank? ? sum_count[x['name']] = x['sum_count'] : sum_count[x['name']] += x['sum_count']

        reports.push(x) if reports.select{ |r| r['name'] == x['name']}.blank?
      end
    end

    reports.each{ |r| r['sum_count'] = sum_count[r['name']]}
  end

  def interface_delay( len )
    chars = ("100".."200").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

end
