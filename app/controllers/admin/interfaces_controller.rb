module Admin
	class InterfacesController < BaseController
		before_action :set_interface, only: [:show, :edit, :update, :destroy]
		before_action :set_customer, only: [:index, :new, :create, :edit]
		respond_to :html, :js

		def index
		end

		def new
			@interface = @customer.interfaces.new
			respond_with @interface
		end

		def create
			@interface = @customer.interfaces.new(interface_params)
			if @interface.save
				flash.now[:notice] = "客户接口创建成功"
				respond_with @interface
			else
				flash.now[:notice] = "客户接口创建失败"
				render :new
			end
		end

		def edit
			respond_with @interface
		end

		def update
			if @interface.update(interface_params)
				flash.now[:notice] = "客户接口更新成功"
				respond_with @interface
			else
				flash.now[:notice] = "客户接口更新失败"
				render :edit
			end
		end

		def show
		end

		def destroy
			@interface.destroy
      			redirect_to admin_customer_interfaces_path(@interface.customer_id)
		end

		private
			def set_interface
				@interface = Interface.find(params[:id])
			end

			def set_customer
				@customer = Customer.find(params[:customer_id])
			end

			def interface_params
				params.require(:interface).permit(:name, :identifier, :address)
			end
	end
end
