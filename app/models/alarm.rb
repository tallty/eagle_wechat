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
			last_time = $redis.hget("machine_last_update_time", "#{machine.identifier}").to_time
			if (Time.now - last_time) > 60
				cache["#{machine.name}"] = ["系统数据", "#{last_time + 60}"]
				params = { title: "#{machine.name}", catagory: "系统数据", alarmed_at: "#{last_time + 60}" }
				Alarm.create!(params)
			end
		end
	end

end
