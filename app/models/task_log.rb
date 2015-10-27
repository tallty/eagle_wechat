# == Schema Information
#
# Table name: task_logs
#
#  id              :integer          not null, primary key
#  start_time      :datetime
#  end_time        :datetime
#  task_identifier :string(255)
#  exception       :string(255)
#  file_name       :text(65535)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  task_name       :string(255)
#

class TaskLog < ActiveRecord::Base

  def self.process
    list = $redis.hgetall("task_log_cache")
    list.map do |e, i|
      # 入库
      item = MultiJson.load(i)
      process_result = item["process_result"]
      log = TaskLog.find_or_create_by task_identifier: item["task_identifier"], start_time: (Time.at(process_result["start_time"].to_f) + 8.hour)
      log.end_time = Time.at(process_result["end_time"].to_f) + 8.hour
      log.exception = process_result["exception"]
      task = Task.where(identifier: log.task_identifier).first
      log.task_name = task.name
      log.file_name = MultiJson.load(process_result["file_list"]).map { |e| e.pop }.join(";")
      log.save

      $redis.hdel("task_log_cache", e)

      if MultiJson.load(log.exception).present?
        $redis.hset("alarm_task_cache", log.task_identifier, log.start_time.strftime("%Y%m%d%H%M%S"))
      end
    end
  end
end
