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
#  address     :string(255)
#

class Interface < ActiveRecord::Base
	belongs_to :customer

	has_many :interfaces_api_users, dependent: :destroy
	has_many :api_users, through: :interfaces_api_users

	after_initialize :generate_identifier

	def generate_identifier
		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
		self.identifier ||= chars.sample(8).join
	end

	def write_interface_to_cache
		$redis.del "interfaces_cache"
		Interface.all.each do |e|
			$redis.hset "interfaces_cache", e.identifier, e.name
		end
	end

	def self.get_interface_name identifier
		$redis.hget "interfaces_cache", identifier
	end

	# 日报表中，当天按小时整理信息
	def by_hour_infos(total_interfaces)
		interface_infos = total_interfaces.select{ |total_interface| total_interface.name == name }
		# 获取top3的时间   
		tops = interface_infos.to(2).collect{|info| info.datetime }
		# 当天当前接口按调用时间排序后调用结果(用于图表)
		every_count = interface_infos.sort{ |x, y| x.datetime <=> y.datetime }.collect{|interface_info| [interface_info.datetime, interface_info.count]}.to_h
		# 当天当前接口调用总次数
		sum_count = every_count.values.sum

		{sum_count: sum_count, every_count: every_count, tops: tops}
	end

	# 周报表、月报表中，按天整理信息
	def by_day_infos(total_interfaces)
		interface_infos = total_interfaces.select{ |total_interface| total_interface.name == name }
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
		# 当前接口对应周的调用总次数
		sum_count = every_count.values.sum
		# 调用信息存入hash
		{sum_count: sum_count, every_count: every_count, tops: tops}
	end

end
