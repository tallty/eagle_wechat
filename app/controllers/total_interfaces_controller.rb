class TotalInterfacesController < ApplicationController
  protect_from_forgery :except => :index
  respond_to :json

  def fetch
    identifier = interface_total_params["identifier"]
    datas = MultiJson.load interface_total_params["data"]
    p datas
    total_interface = nil
    datas.each do |item|
      p item
      total_interface = TotalInterface.find_or_create_by datetime: Time.parse(item["datetime"]), identifier: identifier, name: item["interface_name"]
      total_interface.count = item["interface_count"].to_i
      total_interface.save
    end
    total_interface = nil
    render :text => 'ok'
  end

  private
  def interface_total_params
    params.require(:total_interfaces).permit(:identifier, :data)
  end
end
