# == Schema Information
#
# Table name: alarms
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  category   :string(255)
#  alarmed_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Alarm < ActiveRecord::Base

	# 判断是否需要告警，并返回告警记录
	def self.avtive_alarms(current_customer)
		cache = {}
		current_customer.machines.each do |machine|
			# 服务器最新采集信息时间
			last_time = $redis.hget("machine_last_update_time", "#{machine.identifier}").to_time
			# 缓存信息的长度，用于按负值获取告警之后的最新记录
			length = $redis.llen("#{machine.identifier}_cpu").to_i

			if (Time.now - last_time) > 60
				cache["#{machine.name}"] = ["系统数据", "#{last_time + 60}"]
				params = { identifier: "#{machine.identifier}", 
										title: "#{machine.name}", 
										category: "系统数据", 
										alarmed_at: "#{last_time + 60}", 
										rindex: length }
				Alarm.find_or_create_by!(params)
			end
		end
		return cache
	end

end
