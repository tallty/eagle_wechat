class ApiUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:daily, :week, :month]

	before_action :current_customer
  before_action :select_day, only: [:index, :show]

  def index
    @day_format = @active_day.strftime("%Y-%m-%d")
    @api_users = current_customer.api_users
  end

  def daily

  end

  private
  def current_customer
    Customer.where(id: params[:customer_id]).first
  end

  def select_day
    @active_day = params[:date].blank? ? Date.today : Time.parse(params[:date])
  end
end
