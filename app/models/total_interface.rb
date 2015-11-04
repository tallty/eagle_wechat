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
  attr_accessor :counts

  default_scope { order(count: :DESC) }

  scope :day, -> (date) { by_day(date) }
  scope :week, -> (date) { between_times(date.beginning_of_week, date.end_of_week) }
  scope :month, -> (date) { between_times(date.beginning_of_month, date.end_of_month) }
  scope :select_fields, -> { select("total_interfaces.name, sum(total_interfaces.count) as sum_count") }

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
        info = interface.by_hour_infos(total_interfaces)
        unless info[:sum_count] == 0
          infos[interface.name] = info
        end
      end
    else
      current_customer.interfaces.each do |interface|
        info = interface.by_day_infos(total_interfaces)
        unless info[:sum_count] == 0
          infos[interface.name] = info
        end
      end
    end
    infos = infos.sort{|x, y| y[1][:sum_count] <=> x[1][:sum_count]}.to_h
  end

  # 调用指定借口的客户信息
  def api_user_infos(current_customer, params_name, date)
    total_interfaces = current_customer.total_interfaces.day(date)
    interface = Interface.where(name: params_name).first
    # 选中接口的调用信息，取 :every_count 用于显示图表
    interface_info = interface.by_hour_infos(total_interfaces)

    api_user_infos = {}
    current_customer.api_users.each do |api_user|
      total_interfaces = api_user.total_interfaces.day(date)
      api_user_info = interface.by_hour_infos(total_interfaces)
      unless api_user_info[:sum_count] == 0
        api_user_infos[api_user.company] = api_user_info
      end
    end
    # 循环显示所有调用选中接口的客户的调用信息
    api_user_infos = api_user_infos.sort{ |x,y| y[1][:sum_count] <=> x[1][:sum_count] }.to_h

    # 返回hash：{:interface => interface_info, :api_user => api_user_infos}
    return {:interface => interface_info, :api_users => api_user_infos}
  end

  #计算报表中所有接口调用总数
  def self.total_count total_interfaces
    total_count = 0
    total_interfaces.each do |key, value|
      total_count += value[:sum_count]
    end
    return total_count
  end

end
