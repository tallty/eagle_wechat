class MachineDetailsController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => [:index, :show]

	before_action :current_customer
	def index
		@machines = current_customer.machines.where(operating_status: 1)
	end

	def show
		@machine = Machine.find(params[:id])
	end

	private
	def current_customer
		code = params[:code]
		result = $group_client.oauth.get_user_info(code, "1")
		openid = result.result["UserId"]
		member = Member.where(openid: openid).first
		if member.present?
			session[:openid] = openid
			customer = member.customer
		else
			Customer.first
		end
	end
end
