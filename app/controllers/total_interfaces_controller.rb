class TotalInterfacesController < ApplicationController
  include ActionView::Helpers::NumberHelper
  protect_from_forgery :except => :index
  skip_before_filter :verify_authenticity_token,:only => [:fetch]
  respond_to :json

  def fetch
    TotalInterface.new.analyz_fetch_data interface_total_params
    render :text => 'ok'
  end

  def get_sum
    download_count = number_with_delimiter(TotalInterface.get_sum_from_cache)
    all_count = number_with_delimiter(TotalInterface.sum(:count))
    upload_count = number_with_delimiter(UploadInfo.new.get_total)
    render :json => {all_count: all_count, down: download_count, upload: upload_count}
  end

  private
  def interface_total_params
    params.require(:total_interfaces).permit(:identifier, :data)
  end
end
