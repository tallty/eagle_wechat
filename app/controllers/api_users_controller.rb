class ApiUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:daily, :week, :month]

	before_action :current_customer
  before_action :select_day, only: [:index, :show]

  def index
    @day_format = @active_day.strftime("%Y-%m-%d")
    @api_users = current_customer.api_users.as_json
    @count = TotalInterface.user_analyz(@active_day)
    @api_users.each do |user|
      user['count'] = @count[user['id']]
    end
    @api_users.sort { |a, b| b['count'] <=> a['count'] }
    p @api_users
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
