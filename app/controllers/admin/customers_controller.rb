module Admin
  class CustomersController < BaseController
    before_action :set_customer, only: [:show, :edit, :update, :destroy]
    respond_to :html, :js

    # GET /customers
    # GET /customers.json
    def index
      @customers = Customer.all
    end

    # GET /customers/1
    # GET /customers/1.json
    def show
    end

    # GET /customers/new
    def new
      @customer = Customer.new
      respond_with @customer
    end

    # GET /customers/1/edit
    def edit
      respond_with @customer
    end

    # POST /customers
    # POST /customers.json
    def create
      @customer = Customer.new(customer_params)

      if @customer.save
        flash[:notice] = "创建成功"
        respond_with @customers
      else
        flash[:error] = "创建失败"
        render :new
      end
    end

    # PATCH/PUT /customers/1
    # PATCH/PUT /customers/1.json
    def update
      if @customer.update(customer_params)
        flash[:notice] = "更新成功"
      else
        flash[:error] = "更新失败"
      end
    end

    # DELETE /customers/1
    # DELETE /customers/1.json
    def destroy
      @customer.destroy
      redirect_to admin_customers_path
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_customer
        @customer = Customer.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def customer_params
        params.require(:customer).permit(:name, :addr, :explain, :abbreviation)
      end
  end
end
