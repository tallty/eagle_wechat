class WeatherController < ApplicationController

	before_action :save_session, only: [:active, :history]
	def active
		#活跃报警取出当天的
    @tasks = current_customer.tasks.where("rate >= ? AND updated_at > ? AND updated_at < ?", 10, Date.today.beginning_of_day, Date.today.end_of_day)
	end

	def history
		@customer = Customer.first

		#历史报警取出全部的
    @tasks = @customer.tasks.where("rate > ?", 10) if @customer
	end

	def port
		@interfaces = Interface.all
	end

	def meteorologic
		@task_logs = TaskLog.order(start_time: :DESC).group(:task_name)
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
