class ReportsController < ApplicationController
	before_action :save_session, only: [:index, :week, :month]	
	before_action :select_week, only: [:week, :week_show]
	before_action :select_month, only: [:month, :month_show]
	#日报表
	def index
		@active_day = params[:date].blank? ? (Time.now.to_date - 1) : Time.at(params[:date].to_i / 1000).to_date
		cache = $redis.hvals("interface_reports_cache_#{@active_day.strftime("%F")}")
		@interface_infos = cache.map{ |x| MultiJson.load(x) }
	end

	#日报表详细页
	def show
		@active_day = params[:date].blank? ? (Time.now.to_date - 1) : Time.at(params[:date].to_i / 1000).to_date
		@user_infos = TotalInterface.by_day(@active_day).includes(:api_user).where(name: params[:name]).group(:company).order(:count).sum(:count)
	end

	#周报表
	def week
		@reports = InterfaceReport.reports_between_date(@monday, @sunday)
		@total_count = 0
		@reports.each{ |x| @total_count += x["sum_count"] }
	end

	#周报表详情页
	def week_show
		@user_infos = TotalInterface.between_times(@monday, @sunday).includes(:api_user).where(name: params[:name]).group(:company).order(:count).sum(:count)
	end

	#月报表
	def month
		@reports = InterfaceReport.reports_between_date(@begin_month, @end_month)
	end

	#月报表详情页
	def month_show
		@user_infos = TotalInterface.between_times(@begin_month, @end_month).includes(:api_user).where(name: params[:name]).group(:company).order(:count).sum(:count)
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
