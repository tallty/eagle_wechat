# == Schema Information
#
# Table name: total_interfaces
#
#  id          :integer          not null, primary key
#  datetime    :datetime
#  identifier  :string(255)
#  name        :string(255)
#  count       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  api_user_id :integer
#

class TotalInterface < ActiveRecord::Base
  belongs_to :api_user
  by_star_field :datetime

  # default_scope { order(count: :DESC) }
  scope :day, -> (date) { by_day(date) }
  scope :week, -> (date) { between_times(date.beginning_of_week, date.end_of_week) }
  scope :month, -> (date) { between_times(date.beginning_of_month, date.end_of_month) }

  scope :transfers_sum, -> (date) {by_day(date).where('api_user_id is not null').group(:identifier).sum(:count)}

  scope :user_analyz_daily, -> (date) {by_day(date).where('api_user_id is not null').group(:api_user_id).sum(:count)}
  scope :user_analyz_week, -> (date) {by_week(date).where('api_user_id is not null').group(:api_user_id).sum(:count)}
  scope :user_analyz_month, -> (date) {by_month(date).where('api_user_id is not null').group(:api_user_id).sum(:count)}

  scope :user_analyz_to_api, -> (interface, date) {by_day(date).where(name: interface).group(:api_user_id).sum(:count)}

  scope :user_interface_count, -> (user, date) {by_day(date).where(api_user_id: user.id).group(:name).sum(:count)}

  def analy_api_user_data(date, type)

  end

  # 最新接口调用总数写入redis
  def write_sum_to_cache(day=nil)
    today = day || Time.now.to_date
    list = TotalInterface.transfers_sum(today)
    today_format = today.strftime("%Y-%m-%d")
    list.map do |k, v|
      $redis.hset "interface_sum_cache", "#{today_format}_#{k}", v
    end
    list = nil
  end

  # 统计各接口最新调用数
  def analyz_interface(day=nil)
    process_day = day || Time.now.to_date
    # customers = Customer.all
    day_format = process_day.strftime("%Y-%m-%d")
    sort_times = []
    # customers.each do |customer|
      data = TotalInterface.by_day(process_day).group(:name).sum(:count)
      data.map do |k, v|
        times = TotalInterface.by_day(process_day).where(name: k).group(:datetime).sum(:count)
        times = times.sort{|x, y| y[1] <=> x[1]}.first(3)
        times.each {|t| sort_times << t[0].strftime("%H")}
        param = {
          name: k,
          all_count: v,
          times: sort_times
        }
        customer = Interface.where(name: k).first.customer
        $redis.hset "interface_sort_#{customer.identifier}_#{day_format}", "#{k}", param.to_json
        sort_times.clear
      end
      data = nil
    # end
  end

  def as_json(options=nil)
    {
      datetime: datetime.strftime("%Y-%m-%d %H:%M"),
      identifier: identifier,
      name: name,
      count: count
    }
  end
  def self.fix_name
    items = TotalInterface.all
    items.each do |item|
      interface = Interface.where(identifier: item.name).first
      next if interface.try(:name).blank?
      item.name = name
      item.save
    end
  end

  # 接口报表(日、周、月)
  def self.reports(current_customer, date, method)
    # 查询当前用户指定时间的所有接口调用纪录(数据库记录)
    total_interfaces = current_customer.total_interfaces.send(method, date)

    # 获取当前用户所有接口的统计后的信息:
    # infos = {"interface.name" => {:sum_count => count, :every_count => {datetime => count}, :tops => [date1, date2, date3]}, ...}
    infos = {}
    if method == :day
      current_customer.interfaces.each do |interface|
        infos[interface.name] = interface.by_hour_infos(total_interfaces)
      end
    else
      current_customer.interfaces.each do |interface|
        infos[interface.name] = interface.by_day_infos(total_interfaces)
      end
    end
    infos = infos.sort{|x, y| y[1][:sum_count] <=> x[1][:sum_count]}.to_h
    return infos
  end

  # 调用指定借口的客户调用信息
  def self.api_user_infos(current_customer, interface_name, date, method)
    api_user_infos = {}
    interface = Interface.where(name: interface_name).first
    # 获取当前接口允许的用户
    allow_api_users = interface.api_users.pluck(:id)

    current_customer.api_users.each do |api_user|
      # 用户指定date内所有的调用接口记录
      total_interfaces = api_user.total_interfaces.send(method, date)

      if allow_api_users.include?(api_user.id)
        if method == :day
          api_user_infos[api_user.company] = interface.by_hour_infos(total_interfaces)
        else
          api_user_infos[api_user.company] = interface.by_day_infos(total_interfaces)
        end
        api_user_infos[api_user.company][:allow] = 1
      else
        if method == :day
          api_user_info = interface.by_hour_infos(total_interfaces)
        else
          api_user_info = interface.by_day_infos(total_interfaces)
        end
        # 调用但不属于当前接口允许的用户
        unless api_user_info[:sum_count] == 0
          api_user_infos[api_user.company] = api_user_info
          api_user_infos[api_user.company][:allow] = 0
        end
      end
    end
    # 循环显示所有调用选中接口的客户的调用信息
    api_user_infos = api_user_infos.sort{ |x,y| y[1][:sum_count] <=> x[1][:sum_count] }.to_h
  end

  # 选择借口的图表数据
  def self.interface_info(current_customer, interface_name, date, method)
    total_interfaces = current_customer.total_interfaces.send(method, date)
    interface = Interface.where(name: interface_name).first
    # 选中接口的调用信息，取 :every_count 用于显示图表
    if method == :day
      interface_info = interface.by_hour_infos(total_interfaces)
    else
      interface_info = interface.by_day_infos(total_interfaces)
    end
  end

  #计算报表中所有接口调用总数
  def self.total_count total_interfaces
    total_interfaces.inject(0) {|sum, value| sum + value[1][:sum_count]}
    # total_count = 0
    # total_interfaces.each do |key, value|
    #   total_count += value[:sum_count]
    # end
    # return total_count
  end

end
