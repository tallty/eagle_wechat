class TotalInterfacesController < ApplicationController
  protect_from_forgery :except => :index
  skip_before_filter :verify_authenticity_token,:only => [:fetch]
  respond_to :json

  def fetch
    AnalyzeTask.publish("interface", interface_total_params.to_h)
    identifier = interface_total_params["identifier"]
    datas = MultiJson.load interface_total_params["data"]

    total_interface = nil
    datas.each do |item|
      next if item['appid'].eql?('ZfQg2xyW04X3umRPsi9H')
      # item_name = Interface.where(identifier: item["interface_name"]).first.try(:name)
      item_name = Interface.get_interface_name item['interface_name']
      api_user = ApiUser.where(appid: item["appid"]).first
      if item_name.blank?
        item_name = item["name"]
      end
      datetime = Time.parse(item["datetime"])# + 8.hour
      total_interface = TotalInterface.where(datetime: datetime, identifier: identifier, name: item_name, api_user: api_user)
      if total_interface.blank?
        total_interface = TotalInterface.new
        total_interface.datetime   = datetime
        total_interface.identifier = identifier
        total_interface.name       = item_name
        total_interface.api_user   = api_user
      end
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
