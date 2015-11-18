class MachinesController < ApplicationController
  protect_from_forgery :except => :index
  skip_before_filter :verify_authenticity_token,:only => [:base_hardware_info, :real_hardware_info]
  respond_to :json

  def base_hardware_info
    machine = Machine.where(identifier: base_hardware_params["identifier"]).first
    if machine.nil?
      render :json => { :status => 'error' }
      return
    end
    detail = machine.machine_detail
    if detail.nil?
      detail = MachineDetail.new
      detail.machine = machine
    end
    info = base_hardware_params["info"]
    detail.cpu_name = info["cpu"]["name"]
    detail.cpu_real = info["cpu"]["real"].to_i
    detail.cpu_total = info["cpu"]["total"].to_i
    detail.mhz = info["cpu"]["mhz"]

    detail.memory_swap_total = info["memory"]["swap_total"]
    detail.memory_total = info["memory"]["total"]

    detail.network_address = info["net_work"]["network_address"]
    detail.save

    machine.operating_status = 1
    machine.save
    render :text => 'ok'
  end

  def real_hardware_info
    $redis.lpush "#{real_hardware_params['identifier']}_cpu", "#{real_hardware_params['info']['cpu']}"
    $redis.lpush "#{real_hardware_params['identifier']}_memory", "#{real_hardware_params['info']['memory']}"
    $redis.lpush "#{real_hardware_params['identifier']}_net_work", "#{real_hardware_params['info']['net_work']}"
    $redis.lpush "#{real_hardware_params['identifier']}_file_systems", "#{real_hardware_params['info']['file_system']}"
    $redis.hset("machine_last_update_time", "#{real_hardware_params['identifier']}", Time.now.strftime('%Y-%m-%d %H:%M:%S'))
    render :text => 'ok'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_machine
      @machine = Machine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def base_hardware_params
      params.require(:machine).permit(:identifier, :datetime, info: [
                                                      cpu: [ :name, :mhz, :real, :total], 
                                                      memory: [:swap_total, :total ], 
                                                      net_work: [ :external_address, :network_address ] 
                                                    ])
    end

    def real_hardware_params
      params.require(:machine).permit(:identifier, :datetime, info: [
                                                      cpu: [ :real, :top, :cpu_used, :date_time ], 
                                                      file_system: [:lost_file_system, :percent_used, :date_time],
                                                      memory: [:memory_total_bytes, :total, :memory_free_bytes, :memory_inactive_bytes, :memory_wired_bytes, :date_time ], 
                                                      net_work: [:rx, :tx, :date_time],
                                                      load_average: [:date_time, :load_fifteen_minutes, :load_five_minutes, :load_one_minute]
                                                    ])
    end
end
