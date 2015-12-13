module ReportsHelper
	# 前一天
	def last_day active_day
		active_day - 1.day
	end

	# 后一天
	def next_day active_day
		active_day + 1.day
	end

	# 前一月
	def last_month begin_month
		(begin_month - 1).beginning_of_month.to_time.to_i * 1000
	end

	# 后一月
	def next_month end_month
		(end_month + 1).to_time.to_i * 1000
	end

  # 前一周
	def last_week monday
		(monday - 1).beginning_of_week.to_time.to_i * 1000
	end

	# 后一周
	def next_week sunday
		(sunday + 1).to_time.to_i * 1000
	end

	# 现实中文星期信息
	def week_day week_day_number
		{ "0" => "周日", "1" => "周一", "2" => "周二", "3" => "周三", "4" => "周四", "5" => "周五", "6" => "周六" }[week_day_number]
	end

	# 根据接口调用信息获取图表所需数据
	# 返回值：count ＝ { datetime => count }
	def chart_count(interface_info, tag)
		count = {}
		if tag == "hour"
			interface_info['every_count'].each {|key,value| count[key.strftime("%H").to_i] = value}
		elsif tag == "week"
			interface_info['every_count'].each {|key,value| count[key.to_date.strftime("%w")] = value}
		elsif tag == "month"
			interface_info['every_count'].each {|key,value| count[key.to_date.strftime("%d")] = value}
		end
		return count
	end
end
