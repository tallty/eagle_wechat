class ReportsController < ApplicationController
	def index
		#2015-10-24 接口的记录
		@reports = $redis.hvals("interface_reports_cache_2015-10-24")
		#2015-10-24 接口调用总数
		@total_count = $redis.hget("interface_sum_cache", "X548EYTO_2015-10-24")
	end

	def show

	end
end