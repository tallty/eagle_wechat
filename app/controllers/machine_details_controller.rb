class MachineDetailsController < ApplicationController
	before_action :save_session, only: [:index, :show]
	def index
		#@machines = current_customer.machines.where(operating_status: 1)
	end

	def show
		@machine = Machine.find(params[:id])
	end

	private
	def save_session
		session[:openid] = params[:openid]
	end
end
