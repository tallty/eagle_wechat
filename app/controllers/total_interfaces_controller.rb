class TotalInterfacesController < ApplicationController
  protect_from_forgery :except => :index
  skip_before_filter :verify_authenticity_token,:only => [:fetch]
  respond_to :json

  def fetch
    # BasePublisher.publish("interface", interface_total_params.to_json)
    TotalInterface.new.analyz_fetch_data interface_total_params
    render :text => 'ok'
  end

  def get_sum
    sum_interfaces = TotalInterface.get_sum_from_cache
    render :json => {data: sum_interfaces}
  end

  private
  def interface_total_params
    params.require(:total_interfaces).permit(:identifier, :data)
  end
end
