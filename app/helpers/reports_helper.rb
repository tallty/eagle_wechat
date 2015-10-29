module ReportsHelper

	def last_day active_day
		(active_day - 1).to_time.to_i * 1000
	end

	def next_day active_day
		(active_day + 1).to_time.to_i * 1000
	end

	def last_month active_month
		(active_month.beginning_of_month - 1).beginning_of_month.to_time.to_i * 1000
	end

	def next_month active_month
		(active_month.end_of_month + 1).to_time.to_i * 1000
	end

	def last_week monday
		(monday - 1).beginning_of_month.to_time.to_i * 1000
	end

	def next_week sunday
		(sunday + 1).to_time.to_i * 1000
	end
end
