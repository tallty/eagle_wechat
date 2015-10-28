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
		@week_datas = {}
		(-7..-1).each do |i|
			day = Time.now.to_date + i
			r = $redis.hvals("interface_reports_cache_#{day.strftime("%F")}")
			cache = r.map { |e| MultiJson.load(e) }
			value = cache.collect{|x| x["sum_count"]}.max
			@week_datas[day.wday] = value
		end
	end

	#月报表
	def month
		@month_datas = {}
		(-30..-1).each do |i|
			day = Time.now.to_date + i
			r = $redis.hvals("interface_reports_cache_#{day.strftime("%F")}")
			cache = r.map { |e| MultiJson.load(e) }
			value = cache.collect{|x| x["sum_count"]}.max
			@month_datas[day.strftime("%m-%d")] = value
		end
	end

	#日报表详细页
	def show
		
	end
end
