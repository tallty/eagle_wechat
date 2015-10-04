class MachinesController < ApplicationController
  protect_from_forgery :except => :index  
  respond_to :json

  def create
    @machine = Machine.new(machine_params)
    p @machine
    render :text => 'ok'
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_machine
      @machine = Machine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def machine_params
      params[:machine]
    end
end
