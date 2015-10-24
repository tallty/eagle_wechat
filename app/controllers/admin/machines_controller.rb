module Admin
  class MachinesController < BaseController
    before_action :set_machine, only: [:show, :edit, :update, :destroy]
    respond_to :html, :js

    # GET /machines
    # GET /machines.json
    def index
      @customers = Customer.all
      @customer = Customer.where(id: params[:customer_id]).first
      @machines = Machine.all
    end

    # GET /machines/1
    # GET /machines/1.json
    def show
    end

    # GET /machines/new
    def new
      p params
      @customer = Customer.where(id: params[:customer_id]).first
      @machine = Machine.new
      @machine.customer = @customer
      p @machine
      respond_with @machine
    end

    # GET /machines/1/edit
    def edit
      @customer = Customer.where(id: params[:customer_id]).first
      respond_with @customer, @machine
    end

    # POST /machines
    # POST /machines.json
    def create
      @machine = Machine.new(machine_params)

      if @machine.save
        flash[:notice] = "创建成功"
        respond_with @machine
      else
        flash[:error] = "创建失败"
        render :new
      end
    end

    # PATCH/PUT /machines/1
    # PATCH/PUT /machines/1.json
    def update
      if @machine.update(machine_params)
        flash.now[:notice] = "客户接口更新成功"
        respond_with @machine
      else
        flash.now[:notice] = "客户接口更新失败"
        render :edit
      end
    end

    # DELETE /machines/1
    # DELETE /machines/1.json
    def destroy
      @machine.destroy
      redirect_to admin_customer_machines_path(@machine.customer_id)
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_machine
        @machine = Machine.where(id: params[:id]).first
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def machine_params
        params.require(:machine).permit(:name, :identifier, :explain, :customer_id, :cpu_type)
      end
  end
end
