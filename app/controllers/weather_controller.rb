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
		t = $redis.hvals("task_log_cache")
		@task_logs = t.map { |e| MultiJson.load(e) }
		pp "1111233333333333333333333"
		pp  @task_logs
		pp "1111233333333333333333333"

	end
	
	def result
	end
end
