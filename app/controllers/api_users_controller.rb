class ApiUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:daily, :week, :month]

	before_action :current_customer
  before_action :select_day, only: [:index, :daily]

  def index
    @day_format = @active_day.strftime("%Y-%m-%d")
    @api_users = current_customer.api_users.where("company <> ?", "测试接口[大唐]").as_json
    count = TotalInterface.user_analyz(@active_day)
    @api_users.each do |user|
      user[:count] = count[user[:id]] || 0
    end
    @api_users.sort_by { |u| u.try(:count) }
  end

  def daily
    @api_user = ApiUser.where(id: params[:id]).first
    @interfaces = @api_user.interfaces
    @data = TotalInterface.user_interface_count(@api_user, @active_day)
  end

  def show

  end

  private
  def current_customer
    Customer.where(id: params[:customer_id]).first
  end

  def select_day
    @active_day = params[:date].blank? ? Date.today : Time.parse(params[:date])
  end
end
