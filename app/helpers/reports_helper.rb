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
	def top3(reports, company)
		reports.order(count: :desc).pluck(:company, :count, :datetime).select{ |x| x.first == "#{company}" }.to(2)
	end

	# 整理every_count的格式为: hour => count
	def hour_count interface_info
		hour_count = {}
		interface_info[:every_count].each {|key,value| hour_count[key.strftime("%H").to_i] = value}
		return hour_count
	end

	# 根据接口调用信息获取图表所需数据
	# 返回值：count ＝ { datetime => count }
	def chart_count(interface_info, tag)
		count = {}
		if tag == "hour"
			interface_info[:every_count].each {|key,value| count[key.strftime("%H").to_i] = value}
		elsif tag == "week"
			interface_info[:every_count].each {|key,value| count[key.to_date.strftime("%w")] = value}
		elsif tag == "month"
			interface_info[:every_count].each {|key,value| count[key.to_date.strftime("%d")] = value}
		end
		return count
	end
end
