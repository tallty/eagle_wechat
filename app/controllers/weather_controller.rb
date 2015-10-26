class WeatherController < ApplicationController
	def active
		@customer = Customer.first
    @tasks = @customer.tasks.where("rate >= ?", 60) if @customer
	end

	def history
	end

	def port
	end

	def meteorologic
	end
	
	def result
	end
end
