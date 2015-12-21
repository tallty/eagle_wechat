class WeatherController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => [:port, :meteorologic]

	before_action :current_customer

	# 调用接口
	def port
		@interfaces = @customer.interfaces
	end

	# 气象数据
	def meteorologic
 		@tasks = @customer.tasks.where("tasks.rate is NOT NULL")
 		@process_time = $redis.hgetall("alarm_task_cache")
 		@now_time = Time.now
	end

	# 诊断结果
	def result
	end

	private
	def current_customer
		openid = session[:openid]
		if openid.blank?
			code = params[:code]
			result = $group_client.oauth.get_user_info(code, "1")
			openid = result.result["UserId"]
		end

		member = Member.where(openid: openid).first
		@customer = nil
		if member.present?
			session[:openid] = openid
			@customer = member.customer
		else
			@customer = Customer.first
		end
		return @customer
	end
end
