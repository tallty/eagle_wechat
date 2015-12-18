class AlarmsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:index, :week, :month]

	before_action :current_customer, :only => [:index]

  def index
    page = params[:page] || params['page'] || 1
    @alarms = Alarm.new.get_alarms(@customer).paginate(:page => page, :per_page => 10)
  end

  def show
    @alarm = Alarm.where(id: params[:id]).first
    @catchers = @alarm.send_logs.map {|e| e.get_catcher}.join('; ')
  end

  private
	def current_customer
		openid = session[:openid]
		if openid.blank?
			code = params[:code]
			result = $group_client.oauth.get_user_info(code, "1")
			openid = result.result["UserId"]
		end

		member = Member.where(openid: openid).first
		@customer = nil
		if member.present?
			session[:openid] = openid
			@customer = member.customer
		else
			@customer = Customer.first
		end
		return @customer
	end
end
