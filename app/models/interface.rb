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
require 'thread/pool'
class Interface < ActiveRecord::Base
	belongs_to :customer

	has_many :interfaces_api_users, dependent: :destroy
	has_many :api_users, through: :interfaces_api_users

	after_initialize :generate_identifier

	def init_faraday
		@target_url = "http://61.152.122.112:8080"
		@conn = Faraday.new(:url => @target_url) do |faraday|
      faraday.request :url_encoded
      # faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
	end

	def as_json(options=nil)
		{
			id: id,
			name: name
		}
	end

	def process
		init_faraday

		interfaces = Interface.where("address is not null")
		pool = Thread.pool(5)
		interfaces.each do |interface|
			next if interface.address.blank?
			pool.process { test_interface(interface) }
		end
    pool.shutdown
	end

	def test_interface interface
		# response = @conn.get "#{@target_url}#{interface_address}&appid=ZfQg2xyW04X3umRPsi9H&appkey=xWOX5kAYVSduEl38oJctyRgB2NDMpH"
		response = @conn.get do |req|
			req.url "#{@target_url}#{interface.address}&appid=ZfQg2xyW04X3umRPsi9H&appkey=xWOX5kAYVSduEl38oJctyRgB2NDMpH"
			req.headers['Accept'] = 'application/json'
		end
		if response.status == 200
			runtime = (response.env.response_headers['x-runtime'].to_f * 1000).round(2)
			$redis.hset "interface_run_status_cache", interface.identifier, runtime
		else
			# 接口报警
			params = {
				identifier: interface.identifier,
				title: interface.name,
				category: '接口测试',
				alarmed_at: Time.now,
				rindex: interface.id,
				content: "接口[#{interface.name}]告警: 接口调用异常!!!"
			}
			alarm = Alarm.create(params)
			alarm.send_log.find_or_create_by(accept_user: 'alex6756', info: alarm.content)
		end
		nil
	end

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
		# every_count = interface_infos.sort{ |x, y| x.datetime <=> y.datetime }.collect{|interface_info| [interface_info.datetime, interface_info.count]}.to_h
		sort_count = interface_infos.sort{|x, y| x.datetime <=> y.datetime }
		count = []
		group_list = sort_count.group_by {|item| item.datetime }
		group_list.each {|key, value| count << [key, value.inject(0) { |result, element| result + element.count }]}

		# 当天当前接口调用总次数
		sum_count = count.to_h.values.sum

		{sum_count: sum_count, every_count: count.to_h, tops: tops}
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

	def fix_data_by_day(day)
		TotalInterface.day(day).each do |item|
			interface = Interface.where(name: item.name).first
			$redis.zadd "interface_top_#{interface.identifier}_#{day}", item.count, item.to_json
		end
	end
end
