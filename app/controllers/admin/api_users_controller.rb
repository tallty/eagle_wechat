module Admin
	class ApiUsersController < BaseController
		respond_to :html, :js

		def index
			@interface = Interface.find(params[:interface_id])
			@api_users = @interface.api_users
		end

		def new
			
		end

		def create
			
		end

		def destroy
			
		end
	end
end