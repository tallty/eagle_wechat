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
    # 按照sum_count降序排列每条记录
    infos = infos.sort{|x, y| y[1][:sum_count] <=> x[1][:sum_count]}.to_h
  end

  # 周报表或月报表
  def self.week_or_month_infos(current_customer, date, tag)
    infos = {}
    # 查询当前客户对应周的所有的调用信息
    if tag == 1
      total_interfaces = current_customer.total_interfaces.week(date)
    else
      total_interfaces = current_customer.total_interfaces.month(date)
    end

    # 循环客户所有的接口
    current_customer.interfaces.each do |interface|
      # 调用信息存入hash
      infos[interface.name] = interface.day_infos(total_interfaces)
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
