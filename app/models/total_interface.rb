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

  # 日报表
  def self.day_infos(current_customer, date)
    infos = {}
    # 查询当前客户当天所有的调用信息
    total_interfaces = current_customer.total_interfaces.day(date)

    # 循环客户所有的接口
    current_customer.interfaces.each do |interface|
      # 调用信息存入hash
      infos[interface.name] = interface.infos(total_interfaces)
    end

    infos = infos.sort{|x, y| y[1][:sum_count] <=> x[1][:sum_count]}.to_h
  end

  # 周报表
  def self.week_infos(current_customer, date)
    infos = {}
    # 查询当前客户对应周的所有的调用信息
    total_interfaces = current_customer.total_interfaces.week(date)

    # 循环客户所有的接口
    current_customer.interfaces.each do |interface|
      interface_infos = total_interfaces.select{ |total_interface| total_interface.name == interface.name }

      # 日期及对应的count
      day_count = {}
      interface_infos.each do |interface_info|
        if day_count[interface_info.datetime.strftime("%F")].present?
          day_count[interface_info.datetime.strftime("%F")] += interface_info.count
        else
          day_count[interface_info.datetime.strftime("%F")] = interface_info.count
        end
      end

      # 对应周的top3
      tops = day_count.sort{ |a,b| b[1] <=> a[1] }.to(2).collect{ |x| x[0] }

      # 当前接口对应周 按调用日期排序后调用结果(用于图表)
      every_count = day_count.sort{ |a,b| a[0] <=> b[0] }.to_h
      
      # 当前接口对应周 调用总次数
      sum_count = every_count.values.sum

      # 调用信息存入hash
      infos[interface.name] = {sum_count: sum_count, every_count: every_count, tops: tops}
    end
    infos = infos.sort{|x, y| y[1][:sum_count] <=> x[1][:sum_count]}.to_h
  end

  # 月报表
  def self.month_infos(current_customer, date)
    infos = {}
    # 查询当前客户对应月份的所有的调用信息
    total_interfaces = current_customer.total_interfaces.month(date)

    # 循环客户所有的接口
    current_customer.interfaces.each do |interface|
      interface_infos = total_interfaces.select{ |total_interface| total_interface.name == interface.name }

      # 日期及对应的count
      day_count = {}
      interface_infos.each do |interface_info|
        if day_count[interface_info.datetime.strftime("%F")].present?
          day_count[interface_info.datetime.strftime("%F")] += interface_info.count
        else
          day_count[interface_info.datetime.strftime("%F")] = interface_info.count
        end
      end

      # 对应月份的top3
      tops = day_count.sort{ |a,b| b[1] <=> a[1] }.to(2).collect{ |x| x[0] }

      # 当前接口对应月份 按调用日期排序后调用结果(用于图表)
      every_count = day_count.sort{ |a,b| a[0] <=> b[0] }.to_h
      
      # 当前接口对应月份 调用总次数
      sum_count = every_count.values.sum

      # 调用信息存入hash
      infos[interface.name] = {sum_count: sum_count, every_count: every_count, tops: tops}
    end
    infos = infos.sort{|x, y| y[1][:sum_count] <=> x[1][:sum_count]}.to_h
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
