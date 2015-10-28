class TotalInterfacesController < ApplicationController
  protect_from_forgery :except => :index
  respond_to :json

  def fetch
    identifier = interface_total_params["identifier"]
    datas = MultiJson.load interface_total_params["data"]
    
    total_interface = nil
    datas.each do |item|
      item_name = Interface.where(identifier: item["interface_name"]).first.try(:name)
      api_user = ApiUser.where(appid: item["appid"]).first
      if item_name.blank?
        item_name = item["name"]
      end
      datetime = Time.parse(item["datetime"]) + 8.hour
      total_interface = TotalInterface.find_or_create_by datetime: datetime, identifier: identifier, name: item_name
      total_interface.count = item["interface_count"].to_i
      total_interface.api_user = api_user
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
