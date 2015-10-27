class WeatherController < ApplicationController
	def active
		@customer = Customer.first
    		@tasks = @customer.tasks.where("rate >= ?", 60) if @customer
	end

	def history
		# @customer = Customer.first
		# @tasks = @customer.tasks if @customer
	end

	def port
	end

	def meteorologic
		@task_logs = TaskLog.all.order("start_time DESC")
	end
	
	def result
	end
end
