class TaskLogsController < ApplicationController
  protect_from_forgery :except => :index
  skip_before_filter :verify_authenticity_token,:only => [:fetch]
  respond_to :json

  def fetch
    BasePublisher.publish("task", task_log_params.to_json)
    render :text => 'ok'
  end

  private
  def task_log_params
    params.require(:task_log).permit(:task_identifier, process_result: [
                                                      :start_time, :end_time, :exception, :file_list
                                                    ])
  end
end
