class ReportsController < ApplicationController
	before_action :save_session, only: [:index, :week, :month]	
	before_action :select_week, only: [:week, :week_show]
	before_action :select_month, only: [:month, :month_show]
	#日报表
	def index
		@active_day = params[:date].blank? ? Date.today : Time.at(params[:date].to_i / 1000).to_date
		@day_reports = TotalInterface.day_infos(current_customer, @active_day)
		@total_count = TotalInterface.total_count(@day_reports)
	end

	#日报表详细页
	def show
		# @active_day = params[:date].blank? ? Date.today : Time.at(params[:date].to_i / 1000).to_date
		# @reports = TotalInterface.by_day(@active_day).includes(:api_user).where(name: params[:name])
		# @user_infos = @reports.group(:company).order(:count).sum(:count)

		total_interfaces = current_customer.total_interfaces.day(date)
		interface = Interface.where(name: params[:name]).first
		# 选中接口的调用信息，取 :every_count 用于显示图表
		@interface_info = interface.infos(total_interfaces)

		# 循环显示所有调用选中接口的客户的调用信息
		@api_user_infos = {}
		current_customer.api_users.each do |api_user|
			total_interfaces = api_user.total_interfaces.day(date)
			@api_user_infos[api_user] = interface.infos(total_interfaces)
		end
		@total_count = TotalInterface.total_count(@api_user_infos)
	end

	#周报表
	def week
		@week_reports = TotalInterface.week_infos(current_customer, @monday)
		@total_count = TotalInterface.total_count(@week_reports)
	end

	#周报表详情页
	def week_show
		@user_infos = TotalInterface.between_times(@monday, @sunday).includes(:api_user).where(name: params[:name]).group(:company).order(:count).sum(:count)
	end

	#月报表
	def month
		@month_reports = TotalInterface.month_infos(current_customer, @begin_month)
		@total_count = TotalInterface.total_count(@month_reports)
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
		@monday = params[:date].blank? ? Time.now.beginning_of_week.to_date : Time.at(params[:date].to_i / 1000).beginning_of_week.to_date
		@sunday = @monday.end_of_week.to_date
	end

	#月日期区间
	def select_month
		@begin_month = params[:date].blank? ? Time.now.beginning_of_month.to_date : Time.at(params[:date].to_i / 1000).beginning_of_month.to_date
		@end_month = @begin_month.end_of_month.to_date
	end
end
