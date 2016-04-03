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
    now_day = DateTime.now.strftime("%F")
    $redis.hget("interface_sum_cache", "#{now_day}_v7XGbzhd")
  end

  private
  def interface_total_params
    params.require(:total_interfaces).permit(:identifier, :data)
  end
end
