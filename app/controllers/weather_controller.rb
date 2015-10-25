class WeatherController < ApplicationController
	def active
		@customer = Customer.first
    @tasks = @customer.tasks
	end

	def history
	end

	def port
	end

	def meteorologic
	end

	def statement
	end

	def result
	end
end
