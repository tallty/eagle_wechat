class WeatherController < ApplicationController

	before_action :save_session, only: [:active, :history]
	def active
		@customer = Customer.first
    		@tasks = @customer.tasks.where("rate >= ?", 60) if @customer
	end

	def history
		# @customer = Customer.first
		# @tasks = @customer.tasks if @customer
	end

	def port
		@interfaces = Interface.all.order("created_at DESC")
		
	end

	def meteorologic
		@task_logs = TaskLog.all.order("start_time DESC")[0, 100]
	end
	
	def result
	end

	private
	def save_session
		session[:openid] = params[:openid]
	end

	def delay( len )
    chars = ("100".."200").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
end
