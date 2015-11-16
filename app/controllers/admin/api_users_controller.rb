module Admin
	class ApiUsersController < BaseController
		before_action :set_interface, only: [:index, :new]
		respond_to :html, :js

		def index
			@api_users = @interface.api_users
		end

		def new
			@api_users = current_customer.api_users
			@api_user = InterfacesApiUser.new
			respond_with @api_user
		end

		def create
			InterfacesApiUser.save_interface_api_users(params[:interface_id], params[:interface_api_users])
			respond_to do |format|
				format.js { render js: "location.href = '#{admin_interface_api_users_path(interface_id: params[:interface_id], customer_id: params[:customer_id])}'" }
			end
		end

		def destroy
		end

		private
		def set_interface
			@interface = Interface.find(params[:interface_id])
		end
	end
end