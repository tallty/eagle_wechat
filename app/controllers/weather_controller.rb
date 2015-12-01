class WeatherController < ApplicationController

	before_action :save_session, only: [:active, :history, :port, :meteorologic]

	def active
		# 服务器上报信息：2次/m
		# 活跃报警：检测当前客户的所有服务器，判断当前时间与其最新上报时间的差值是否大于1min
		@machines_status = Alarm.avtive_alarms(current_customer)
	end

	# 历史告警
	def history
		#历史告警取出已解除的告警
    @history_alarms = []
    Alarm.order(created_at: :DESC).each do |alarm|
    	if alarm.warn_over_time.present?
    		@history_alarms.push(alarm)
    	end
    end
	end

	# 调用接口
	def port
		@interfaces = current_customer.interfaces
	end

	# 气象数据
	def meteorologic
 		@tasks = current_customer.tasks.where("tasks.rate is NOT NULL")
 		@process_time = $redis.hgetall("alarm_task_cache")
 		@now_time = Time.now
	end

	# 诊断结果
	def result
	end

	private
	def save_session
		session[:openid] = params[:openid]
	end
end
