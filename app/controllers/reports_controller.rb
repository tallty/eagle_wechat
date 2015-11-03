class ReportsController < ApplicationController

	before_action :save_session, only: [:index, :week, :month]	
	before_action :select_day, only: [:index, :show]
	before_action :select_week, only: [:week, :week_show]
	before_action :select_month, only: [:month, :month_show]

	#日报表
	def index
		@day_reports = TotalInterface.reports(current_customer, @active_day, 0)
		@total_count = TotalInterface.total_count(@day_reports)
	end

	#周报表
	def week
		@week_reports = TotalInterface.reports(current_customer, @monday, 1)
		@total_count = TotalInterface.total_count(@week_reports)
	end

	#月报表
	def month
		@month_reports = TotalInterface.reports(current_customer, @begin_month, 2)
		@total_count = TotalInterface.total_count(@month_reports)
	end

	#日报表详细页
	def show
		total_interfaces = current_customer.total_interfaces.day(@active_day)
		interface = Interface.where(name: params[:name]).first
		# 选中接口的调用信息，取 :every_count 用于显示图表
		@interface_info = interface.by_hour_infos(total_interfaces)

		@api_user_infos = {}
		current_customer.api_users.each do |api_user|
			total_interfaces = api_user.total_interfaces.day(@active_day)
			@api_user_infos[api_user.company] = interface.by_hour_infos(total_interfaces)
		end
		# 循环显示所有调用选中接口的客户的调用信息
		@api_user_infos = @api_user_infos.sort{ |x,y| y[1][:sum_count] <=> x[1][:sum_count] }.to_h

		# 调用总数
		@total_count = TotalInterface.total_count(@api_user_infos)
	end

	#周报表详情页
	def week_show
		#@user_infos = TotalInterface.between_times(@monday, @sunday).includes(:api_user).where(name: params[:name]).group(:company).order(:count).sum(:count)
		
		total_interfaces = current_customer.total_interfaces.week(@monday)
		interface = Interface.where(name: params[:name]).first
		# 选中接口的调用信息，取 :every_count 用于显示图表
		@interface_info = interface.by_day_infos(total_interfaces)

		@api_user_infos = {}
		current_customer.api_users.each do |api_user|
			total_interfaces = api_user.total_interfaces.week(@monday)
			@api_user_infos[api_user.company] = interface.by_day_infos(total_interfaces)
		end
		# 循环显示所有调用选中接口的客户的调用信息
		@api_user_infos = @api_user_infos.sort{ |x,y| y[1][:sum_count] <=> x[1][:sum_count] }.to_h

		# 调用总数
		@total_count = TotalInterface.total_count(@api_user_infos)
	end

	#月报表详情页
	def month_show
		#@user_infos = TotalInterface.between_times(@begin_month, @end_month).includes(:api_user).where(name: params[:name]).group(:company).order(:count).sum(:count)
	
		total_interfaces = current_customer.total_interfaces.month(@begin_month)
		interface = Interface.where(name: params[:name]).first
		# 选中接口的调用信息，取 :every_count 用于显示图表
		@interface_info = interface.by_day_infos(total_interfaces)

		@api_user_infos = {}
		current_customer.api_users.each do |api_user|
			total_interfaces = api_user.total_interfaces.month(@begin_month)
			@api_user_infos[api_user.company] = interface.by_day_infos(total_interfaces)
		end
		# 循环显示所有调用选中接口的客户的调用信息
		@api_user_infos = @api_user_infos.sort{ |x,y| y[1][:sum_count] <=> x[1][:sum_count] }.to_h

		# 调用总数
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
