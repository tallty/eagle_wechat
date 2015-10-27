# == Schema Information
#
# Table name: task_logs
#
#  id              :integer          not null, primary key
#  start_time      :datetime
#  end_time        :datetime
#  task_identifier :string(255)
#  exception       :string(255)
#  file_name       :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  task_name       :string(255)
#  identifier      :string(255)
#

class TaskLog < ActiveRecord::Base

  def self.process
    list = $redis.hvals("task_log_cache").map { |e| MultiJson.load e }
    list.each do |item|
      # 入库
      process_result = item["process_result"]
      log = TaskLog.find_or_create_by task_identifier: item["task_identifier"], start_time: Time.at(process_result["start_time"].to_f)
      log.end_time = Time.at(process_result["end_time"].to_f)
      log.exception = process_result["exception"]
      log.name = Task.where(identifier: log.task_identifier).first.name
      log.file_name = MultiJson.load(process_result["file_list"]).map { |e| e.pop }.join(";")
      log.save
    end
  end
end
