# == Schema Information
#
# Table name: interfaces
#
#  id          :integer          not null, primary key
#  identifier  :string(255)
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :integer
#

class Interface < ActiveRecord::Base
	belongs_to :customer

	after_initialize :generate_identifier

	def generate_identifier
		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
		self.identifier ||= chars.sample(8).join
	end

	def infos(total_interfaces)
		interface_infos = total_interfaces.select{ |total_interface| total_interface.name == name }
    # 获取top3的时间   
    tops = interface_infos.to(2).collect{|info| info.datetime }
    # 当天当前接口按调用时间排序后调用结果(用于图表)
    every_count = interface_infos.sort{ |x, y| x.datetime <=> y.datetime }.collect{|interface_info| [interface_info.datetime, interface_info.count]}.to_h
    # 当天当前接口调用总次数
    sum_count = every_count.values.sum

    {sum_count: sum_count, every_count: every_count, tops: tops}
	end

end
