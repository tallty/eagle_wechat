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
      
      next if item["task_identifier"].blank?
      start_time = Time.at(process_result['start_time'].to_f)
      end_time = Time.at(process_result['end_time'].to_f)
      log = TaskLog.where(task_identifier: item['task_identifier'], start_time: start_time).first
      if log.blank?
        log = TaskLog.new
      end
      log.task_identifier = item['task_identifier']
      log.start_time      = start_time
      log.end_time        = end_time
      log.exception       = process_result["exception"]
      log.task_name       = Task.get_task_name item['task_identifier']
      log.file_name       = MultiJson.load(process_result["file_list"]).join(";")
      log.save

      $redis.hdel("task_log_cache", e)
      exception = MultiJson.load(log.exception) rescue ""
      if exception.present?
        $redis.hset("alarm_task_cache", log.task_identifier, log.start_time.strftime("%Y%m%d%H%M%S"))
      end
    end
  end

  def self.verify
    tasks = Task.where('rate > 0').pluck(:identifier, :rate)
    tasks.each do |item|
      log = TaskLog.where(task_identifier: item[0]).last
      begin
        time_out = (Time.now - log.start_time) / 60 
        if time_out - item[-1] > 2
          $redis.hset("alarm_task_cache", log.task_identifier, log.start_time.strftime("%Y%m%d%H%M%S"))
        end  
      rescue Exception => e
        next
      end
      
    end
  end
end
