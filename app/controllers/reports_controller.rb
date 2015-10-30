class ReportsController < ApplicationController
	before_action :save_session, only: [:index, :week, :month]	
	before_action :select_week, only: [:week, :week_show]
	before_action :select_month, only: [:month, :month_show]
	#日报表
	def index
		@active_day = params[:date].blank? ? Time.now.to_date : Time.at(params[:date].to_i / 1000).to_date
		cache = $redis.hvals("interface_reports_cache_#{@active_day.strftime("%F")}")
		@interface_infos = cache.map{ |x| MultiJson.load(x) }
	end

	#日报表详细页
	def show
		@active_day = params[:date].blank? ? Time.now.to_date : Time.at(params[:date].to_i / 1000).to_date
		# {user_name => count, ...}
		Customer.first.api_users.each do |user|
			@user_infos["#{user.company}"] = user.total_interfaces.day(@active_day).where(name: params[:name]).sum(:count)[params[:name]]
		end
	end

	#周报表
	def week
		@reports = InterfaceReport.reports_between_date(@monday, @sunday)
	ends

	#周报表详情页
	def week_show

	end

	#月报表
	def month
		@reports = InterfaceReport.reports_between_date(@begin_month, @end_month)
	end

	#月报表详情页
	def month_show

	end

	private
	def save_session
		session[:openid] = params[:openid]
	end

	#周日期区间
	def select_week
		begin_date = params[:date].blank? ? Time.now.beginning_of_week.to_date : Time.at(params[:date].to_i / 1000).beginning_of_week.to_date
		end_date = begin_date.end_of_week.to_date
		@monday = begin_date
		@sunday = end_date
	end

	#月日期区间
	def select_month
		begin_date = params[:date].blank? ? Time.now.beginning_of_month.to_date : Time.at(params[:date].to_i / 1000).beginning_of_month.to_date
		end_date = begin_date.end_of_month.to_date
		@begin_month = begin_date
		@end_month = end_date
	end
end
