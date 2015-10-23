module Admin
	class TasksController < BaseController
		def index
			@customer = Customer.find(params[:customer_id])
		end

		def show
			
		end
	end
end
