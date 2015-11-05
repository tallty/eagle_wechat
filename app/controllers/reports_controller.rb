class ReportsController < ApplicationController

	before_action :save_session, only: [:index, :week, :month]	
	before_action :select_day, only: [:index, :show]
	before_action :select_week, only: [:week, :week_show]
	before_action :select_month, only: [:month, :month_show]

	#日报表
	def index
		@day_reports = TotalInterface.reports(current_customer, @active_day, :day)
		@total_count = TotalInterface.total_count(@day_reports)
		require 'pp'
		pp @day_reports, "+++++++++++++++++++++++++++++++++++++++++++++++++++++++", @total_count
	end

	#周报表
	def week
		@week_reports = TotalInterface.reports(current_customer, @monday, :week)
		@total_count = TotalInterface.total_count(@week_reports)
	end

	#月报表
	def month
		@month_reports = TotalInterface.reports(current_customer, @begin_month, :month)
		@total_count = TotalInterface.total_count(@month_reports)
	end

	#日报表详细页
	def show
		# 借口的图表数据
		@interface_info = TotalInterface.interface_info(current_customer, params[:name], @active_day, :day)
		# 调用已选借口的所有客户信息
		@api_user_infos = TotalInterface.api_user_infos(current_customer, params[:name], @active_day, :day)
		@total_count = TotalInterface.total_count(@api_user_infos)
	end

	#周报表详情页
	def week_show
		# 借口的图表数据
		@interface_info = TotalInterface.interface_info(current_customer, params[:name], @monday, :week)
		# 调用已选借口的所有客户信息
		@api_user_infos = TotalInterface.api_user_infos(current_customer, params[:name], @monday, :week)
		@total_count = TotalInterface.total_count(@api_user_infos)
	end

	#月报表详情页
	def month_show
	# 借口的图表数据
		@interface_info = TotalInterface.interface_info(current_customer, params[:name], @begin_month, :month)
		# 调用已选借口的所有客户信息
		@api_user_infos = TotalInterface.api_user_infos(current_customer, params[:name], @begin_month, :month)
		@total_count = TotalInterface.total_count(@api_user_infos)
	end

	private
	def save_session
		session[:openid] = params[:openid]
	end

	# 已选日期	
	def select_day
		@active_day = params[:date].blank? ? Date.today : Time.at(params[:date].to_i / 1000).to_date
	end

	# 已选周日期区间
	def select_week
		@monday = params[:date].blank? ? Time.now.beginning_of_week.to_date : Time.at(params[:date].to_i / 1000).beginning_of_week.to_date
		@sunday = @monday.end_of_week.to_date
	end

	# 已选月日期区间
	def select_month
		@begin_month = params[:date].blank? ? Time.now.beginning_of_month.to_date : Time.at(params[:date].to_i / 1000).beginning_of_month.to_date
		@end_month = @begin_month.end_of_month.to_date
	end
end
