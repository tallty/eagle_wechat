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
      
      if item["task_identifier"].blank?
        $redis.hdel "task_log_cache", e
        next
      end
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

      $redis.hset("alarm_task_cache", log.task_identifier, start_time)
      
      $redis.hdel("task_log_cache", e)
      params = {identifier: e, title: machine.name, category: '气象数据', alarmed_at: last_time, rindex: log.id}
      # 数据处理异常,告警
      exception = MultiJson.load(log.exception) rescue ""
      if exception.present?
        params['content'] = "数据[#{log.task_name}]告警:数据解析异常, 需要马上解决."
        Alarm.new.build_task_alarm(params)
        next
      end

      # 数据超时未解析到新数据,告警
      
    end
  end


end
