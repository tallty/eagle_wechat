class TaskLogsController < ApplicationController
  protect_from_forgery :except => :index
  skip_before_filter :verify_authenticity_token,:only => [:base_hardware_info, :real_hardware_info]
  respond_to :json

  def run
    p params
  end

end
