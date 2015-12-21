class ApiUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:index, :week, :month]

	before_action :current_customer
  before_action :select_day, only: [:index, :daily, :daily_index]
  before_action :select_week, only: [:week_index]
  before_action :select_month, only: [:month_index]

  def index
    route = params[:route] || "daily"
    redirect_to "/customers/#{params['customer_id']}/api_users/#{route}_index?date=#{params['date']}"
  end

  def daily_index
    @day_format = @active_day.strftime("%Y-%m-%d")
    @api_users = current_customer.api_users.where("company <> ?", "测试接口[大唐]").as_json
    count = TotalInterface.user_analyz_daily(@customer, @active_day)
    @api_users.each do |user|
      user[:count] = count[user[:id]] || 0
    end
    @api_users.sort! { |x, y| y[:count] <=> x[:count] }
  end

  def week_index
    @day_format = @active_day.strftime("%Y-%m-%d")
    @api_users = current_customer.api_users.where("company <> ?", "测试接口[大唐]").as_json
    count = TotalInterface.user_analyz_week(@customer, @active_day)
    @api_users.each do |user|
      user[:count] = count[user[:id]] || 0
    end
    @api_users.sort! { |x, y| y[:count] <=> x[:count] }
  end

  def month_index
    @day_format = @active_day.strftime("%Y-%m-%d")
    @api_users = current_customer.api_users.where("company <> ?", "测试接口[大唐]").as_json
    count = TotalInterface.user_analyz_month(@customer, @active_day)
    @api_users.each do |user|
      user[:count] = count[user[:id]] || 0
    end
    @api_users.sort! { |x, y| y[:count] <=> x[:count] }
  end

  def daily
    logger.warn params
    @api_user = ApiUser.where(id: params[:user_id]).first
    @interfaces = @api_user.interfaces.as_json
    data = TotalInterface.user_interface_count(@api_user, @active_day)
    @interfaces.each {|e| e[:count] = data[e[:name]] || 0}
    @interfaces.sort! {|x, y| y[:count] <=> x[:count]}
  end

  def show

  end

  private
  def current_customer
    @customer = Customer.where(id: params[:customer_id]).first
  end

  def select_day
    @active_day = params[:date].blank? ? Date.today : Time.parse(params[:date])
  end
end
