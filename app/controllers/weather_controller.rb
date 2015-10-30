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
		@interfaces = Interface.all
	end

	def meteorologic
		@task_logs = TaskLog.all.order("start_time DESC")
	end
	
	def result
	end

	private
	def save_session
		session[:openid] = params[:openid]
	end
end
