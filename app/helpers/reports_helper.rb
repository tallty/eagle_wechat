module ReportsHelper

	def last_day active_day
		(active_day - 1).to_time.to_i * 1000
	end

	def next_day active_day
		(active_day + 1).to_time.to_i * 1000
	end

	def last_month begin_month
		(begin_month - 1).beginning_of_month.to_time.to_i * 1000
	end

	def next_month end_month
		(end_month + 1).to_time.to_i * 1000
	end

	def last_week monday
		(monday - 1).beginning_of_week.to_time.to_i * 1000
	end

	def next_week sunday
		(sunday + 1).to_time.to_i * 1000
	end

	#统计指定客户的top3 [["客户名称", count, datetime], ...]
	def top3(reports company)
		reports.order(count: :desc).pluck(:company, :count, :datetime).select{ |x| x.first == "#{company}" }.to(2)
	end
end
