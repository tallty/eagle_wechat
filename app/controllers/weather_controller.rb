class WeatherController < ApplicationController

	before_action :save_session, only: [:active, :history]
	def active
		@customer = Customer.first

		#活跃报警取出当天的
    @tasks = @customer.tasks.where("rate >= ? AND updated_at > ? AND updated_at < ?", 10, Date.today.beginning_of_day, Date.today.end_of_day) if @customer
	end

	def history
		@customer = Customer.first

		#历史报警取出全部的
    @tasks = @customer.tasks.where("rate >= ?", 10) if @customer
	end

	def port
		@interfaces = Interface.all
	end

	def meteorologic
		@task_logs = TaskLog.all.order("start_time DESC")
	end

	def result
		@customer = Customer.first
    @tasks = @customer.tasks.where("rate >= ?", 10) if @customer
	end

	private
	def save_session
		session[:openid] = params[:openid]
	end
end
