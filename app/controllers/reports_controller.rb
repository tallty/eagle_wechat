class ReportsController < ApplicationController
	def index
		if params[:date].present?
			@selected = Time.at(params[:date].to_i / 1000).strftime("%F")
			cache = $redis.hvals("interface_reports_cache_#{@selected}")
	    @reports = cache.map { |e| MultiJson.load(e) }
			#@total_count = $redis.hget("interface_sum_cache", "X548EYTO_#{selected}")
		else
			#2015-10-24 接口的记录
			cache = $redis.hvals("interface_reports_cache_#{(Time.now.to_date - 1).strftime("%F")}")
	    @reports = cache.map { |e| MultiJson.load(e) }
			#2015-10-24 接口调用总数
			#@total_count = $redis.hget("interface_sum_cache", "X548EYTO_#{(Time.now.to_date - 1).strftime("%F")}")
		end	
	end

	#周报表
	def week
		begin_date = params[:date].blank? ? Time.now.beginning_of_week.to_date : Time.at(params[:date].to_i / 1000).beginning_of_week.to_date
		end_date = begin_date.end_of_week.to_date

		@monday = begin_date
		@sunday = end_date

		@reports = InterfaceReport.reports_between_date(begin_date, end_date)

		#@reports = [{"datetime"=>"2015-10-26", "identifier"=>"X548EYTO", "name"=>"区县预警", "sum_count"=>1609, "first_times"=>"2015-10-26 10:00:00 UTC", "first_count"=>18, "second_times"=>"2015-10-26 10:00:00 UTC", "second_count"=>18, "third_times"=>"2015-10-26 01:00:00 UTC", "third_count"=>59}, {"datetime"=>"2015-10-26", "identifier"=>"X548EYTO", "name"=>"云图", "sum_count"=>494, "first_times"=>"2015-10-26 10:00:00 UTC", "first_count"=>12, "second_times"=>"2015-10-26 04:00:00 UTC", "second_count"=>39, "third_times"=>"2015-10-26 01:00:00 UTC", "third_count"=>40}]
	end

	#月报表
	def month
		begin_date = params[:date].blank? ? Time.now.beginning_of_month.to_date : Time.at(params[:date].to_i / 1000).to_date
		end_date = begin_date.end_of_month.to_date

		@active_month = begin_date

		@reports = InterfaceReport.reports_between_date(begin_date, end_date)
	end

	#日报表详细页
	def show
		
	end
end
