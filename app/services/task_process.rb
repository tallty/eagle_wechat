class TaskProcess

  # 解析接收到的数据,如果数据有异常,报警
  def self.push(raw_post)
    item = MultiJson.load raw_post
    begin
      process_result = item["process_result"]
      return if item["task_identifier"].blank?

      file_name = MultiJson.load(process_result['file_list']).join(';') rescue ""
      log_params = {
        task_identifier: item['task_identifier'],
        start_time: Time.at(process_result['start_time'].to_f),
        end_time: Time.at(process_result['end_time'].to_f),
        exception: process_result['exception'],
        task_name: Task.get_task_name(item['task_identifier']),
        file_name: file_name
      }
      log = TaskLog.new.build_task_log(log_params)
      $redis.hset("alarm_task_cache", log.task_identifier, log.start_time)
    rescue => e
      Rails.logger.warn e
    end
  end
end
