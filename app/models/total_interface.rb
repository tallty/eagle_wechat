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
    if tag == :day
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

  #计算报表中所有接口调用总数
  def self.total_count total_interfaces
    total_count = 0
    total_interfaces.each do |key, value|
      total_count += value[:sum_count]
    end
    return total_count
  end

end
