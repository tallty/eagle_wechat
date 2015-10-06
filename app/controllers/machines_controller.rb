class MachinesController < ApplicationController
  protect_from_forgery :except => :index
  skip_before_filter :verify_authenticity_token,:only => [:create]
  respond_to :json

  def create
    machine = Machine.where(identifier: machine_params["identifier"]).first
    detail = machine.machine_detail
    if detail.nil?
      detail = MachineDetail.new
      detail.machine = machine
    end
    detail.cpu_name = machine_params["info"]["cpu"]["name"]
    detail.cpu_real = machine_params["info"]["cpu"]["real"].to_i
    detail.cpu_total = machine_params["info"]["cpu"]["total"].to_i
    detail.mhz = machine_params["info"]["cpu"]["mhz"]
    
    detail.memory_swap_total = machine_params["info"]["memory"]["swap_total"]
    detail.memory_total = machine_params["info"]["memory"]["total"]

    detail.network_address = machine_params["info"]["net_work"]["network_address"]
    detail.save

    render :text => 'ok'
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_machine
      @machine = Machine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def machine_params
      params.require(:machine).permit(:identifier, info: [ 
                                                      cpu: [ :name, :mhz, :real, :total], 
                                                      memory: [:swap_total, :total ], 
                                                      net_work: [ :external_address, :network_address ] 
                                                    ])
    end
end
