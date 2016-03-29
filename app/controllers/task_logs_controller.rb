class TaskLogsController < ApplicationController
  protect_from_forgery :except => :index
  skip_before_filter :verify_authenticity_token,:only => [:fetch]
  respond_to :json

  def fetch
    # BasePublisher.publish("task", task_log_params.to_json)

    return if task_log_params["task_identifier"].blank?
    process_result = task_log_params["process_result"]
    file_name = MultiJson.load(process_result['file_list']).join(';') rescue ""
    log_params = {
      task_identifier: task_log_params['task_identifier'],
      start_time: Time.at(process_result['start_time'].to_f),
      end_time: Time.at(process_result['end_time'].to_f),
      exception: process_result['exception'],
      task_name: Task.get_task_name(task_log_params['task_identifier']),
      file_name: file_name
    }
    log = TaskLog.new.build_task_log(log_params)
    $redis.hset("alarm_task_cache", log.task_identifier, log.start_time)
    render :text => 'ok'
  end

  private
  def task_log_params
    params.require(:task_log).permit(:task_identifier, process_result: [
                                                      :start_time, :end_time, :exception, :file_list
                                                    ])
  end
end
