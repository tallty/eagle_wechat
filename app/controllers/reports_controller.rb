class ReportsController < ApplicationController
	before_action :save_session, only: [:index, :week, :month]	
	before_action :select_week, only: [:week, :week_show]
	before_action :select_month, only: [:month, :month_show]
	#日报表
	def index
		@active_day = params[:date].blank? ? Time.now.to_date : Time.at(params[:date].to_i / 1000).to_date
		cache = $redis.hvals("interface_reports_cache_#{@active_day.strftime("%F")}")
		@reports = cache.map{ |x| MultiJson.load(x) }
		#@total_count = $redis.hget("interface_sum_cache", "X548EYTO_#{@active_day}")
	end

	#日报表详细页
	def show
		@active_day = params[:date].blank? ? Time.now.to_date : Time.at(params[:date].to_i / 1000).to_date
		# @count_array = [count, ...]
		@count_array = []
		cache = Customer.first.api_users.joins("LEFT JOIN  `total_interfaces` ON `total_interfaces`.`api_user_id` = `api_users`.`id` and total_interfaces.name= #{params[:name]}").group("api_users.id").pluck("api_users.company", "sum(total_interfaces.count)")
		# @user_infos = [[name, count],...]
		@user_infos = cache.each{ |x| x[1].nil? ? x[1] = 0 : x[1] }
		@user_infos.each{ |x| @count_array.push(x[1])}
		@max_user = @user_infos.select{ |x| x[1] == @count_array.max }[0][0]
	end

	#周报表
	def week
		@reports = InterfaceReport.reports_between_date(begin_date, end_date)
		#@reports = [{"datetime"=>"2015-10-26", "identifier"=>"X548EYTO", "name"=>"区县预警", "sum_count"=>1609, "first_times"=>"2015-10-26 10:00:00 UTC", "first_count"=>18, "second_times"=>"2015-10-26 10:00:00 UTC", "second_count"=>18, "third_times"=>"2015-10-26 01:00:00 UTC", "third_count"=>59}, {"datetime"=>"2015-10-26", "identifier"=>"X548EYTO", "name"=>"云图", "sum_count"=>494, "first_times"=>"2015-10-26 10:00:00 UTC", "first_count"=>12, "second_times"=>"2015-10-26 04:00:00 UTC", "second_count"=>39, "third_times"=>"2015-10-26 01:00:00 UTC", "third_count"=>40}]
	end

	#周报表详情页
	def week_show

	end

	#月报表
	def month
		@reports = InterfaceReport.reports_between_date(begin_date, end_date)
	end

	#月报表详情页
	def month_show

	end

	private
	def save_session
		session[:openid] = params[:openid]
	end

	#周选择功能
	def select_week
		begin_date = params[:date].blank? ? Time.now.beginning_of_week.to_date : Time.at(params[:date].to_i / 1000).beginning_of_week.to_date
		end_date = begin_date.end_of_week.to_date
		@monday = begin_date
		@sunday = end_date
	end

	#月选择功能
	def select_month
		begin_date = params[:date].blank? ? Time.now.beginning_of_month.to_date : Time.at(params[:date].to_i / 1000).to_date
		end_date = begin_date.end_of_month.to_date
		@active_month = begin_date
	end
end
