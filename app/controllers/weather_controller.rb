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
<<<<<<< HEAD
		@task_logs = t.map { |e| MultiJson.load(e) }
=======
		@tasks_logs = t.map { |e| MultiJson.load(e) }
>>>>>>> 7656fa29784d0963351dd9c8eac4cf83d006697a
	end
	
	def result
	end
end
