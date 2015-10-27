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
	end
	
	def result
	end
end
