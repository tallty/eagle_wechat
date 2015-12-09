class TaskLogsController < ApplicationController
  protect_from_forgery :except => :index
  skip_before_filter :verify_authenticity_token,:only => [:fetch]
  respond_to :json

  def fetch
    process_file_list = MultiJson.load task_log_params["process_result"]["file_list"]
    if process_file_list.present?
      $redis.hset "task_log_cache", "#{task_log_params[:task_identifier]}_#{Time.now.to_i}", task_log_params.to_json
    end
    AnalyzeTask.publish("task", "get task log.")
    render :text => 'ok'
  end

  private
  def task_log_params
    params.require(:task_log).permit(:task_identifier, process_result: [
                                                      :start_time, :end_time, :exception, :file_list
                                                    ])
  end
end
