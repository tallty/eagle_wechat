class WeatherController < ApplicationController
	def active
		@customer = Customer.first
    @tasks = @customer.tasks if @customer
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
